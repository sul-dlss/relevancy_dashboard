class Search < ApplicationRecord
  has_many :search_results

  after_commit :generate_search_results_data

  def generate_search_results_data
    GenerateSearchResultsDataJob.perform_later(self)
  end

  def params
    Rack::Utils.parse_nested_query query_params
  end
end
