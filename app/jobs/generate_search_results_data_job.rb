class GenerateSearchResultsDataJob < ApplicationJob
  def perform(search)
    Endpoint.find_each do |endpoint|
      search_result = SearchResult.find_or_create_by(endpoint: endpoint, search: search)
      search_result.retrieve_search_results!
    end
    _report, score = DifferenceReporter.new(search.search_results).report
    search.update_columns(score: score) # Skipping callbacks here on purpose
  end
end
