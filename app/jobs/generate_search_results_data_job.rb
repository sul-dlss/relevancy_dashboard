class GenerateSearchResultsDataJob < ApplicationJob
  def perform(search, e = nil)
    Endpoint.find_each do |endpoint|
      next unless e.nil? || e.id == endpoint.id

      search_result = SearchResult.find_or_create_by(endpoint: endpoint, search: search)
      search_result.retrieve_search_results!
    end
    score = DifferenceReporter.new(search.search_results).change_score
    search.update_columns(score: score) # Skipping callbacks here on purpose
  end
end
