class Search < ApplicationRecord
  has_many :search_results, dependent: :delete_all
  paginates_per 100

  after_commit :generate_search_results_data

  def generate_search_results_data
    GenerateSearchResultsDataJob.perform_later(self)
  end

  def params
    if query_params&.starts_with?('{')
      JSON.parse(query_params)
    else
      Rack::Utils.parse_nested_query query_params
    end
  end
end
