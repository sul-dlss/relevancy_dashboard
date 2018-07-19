class GenerateSearchResultsDataJob < ApplicationJob
  def perform(search)
    Endpoint.find_each do |endpoint|
      search_result = SearchResult.find_or_create_by(endpoint: endpoint, search: search)
      search_result.retrieve_search_results!
    end
  end
end
