class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /searches
  # GET /searches.json
  def index
    @searches = Search.all.order(
      case params[:sort]
      when 'query_params'
        { query_params: :asc }
      when 'created_at'
        { created_at: :desc }
      else
        { score: :desc }
      end
    ).where(
      if params[:score]
        ['score >= ? AND score < ?', *params[:score]]
      elsif params[:like]
        ['query_params LIKE ?', "%#{params[:like]}%"]
      else
        {}
      end
    ).page(params[:page]).per(params[:per_page])
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def explain
    @search = Search.find(params[:search_id])
    @search_result = @search.search_results.find(params[:search_result_id])
    @id = params[:id]

    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def refresh
    respond_to do |format|
      if GenerateSearchResultsDataJob.perform_now(@search)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { redirect_to @search, notice: 'Search was not updated.' }
        format.json { render :show, status: :unprocessable_entity, location: @search }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:query_params)
    end
end
