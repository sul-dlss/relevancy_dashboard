class SearchResult < ApplicationRecord
  belongs_to :endpoint
  belongs_to :search

  def retrieve_search_results!
    response = HTTP.get(endpoint.url, params: search.params.merge('fl' => 'id', 'wt' => 'csv', 'rows' => 20))

    update(response: response.body)
  end
end
