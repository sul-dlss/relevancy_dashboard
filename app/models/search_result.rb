class SearchResult < ApplicationRecord
  belongs_to :endpoint
  belongs_to :search

  def request_url
    "#{endpoint.url}?#{search.params.merge('fl' => 'id,title_245a_display,score', 'wt' => 'json', 'rows' => 20).to_query}"
  end

  def explain_url
    request_url + '&debugQuery=true&facet=false'
  end

  def data
    @data ||= JSON.parse(response)
  end

  def docs
    @docs ||= data.fetch('response', {}).fetch('docs', []).fill({}, num_docs, 20 - num_docs)
  end

  def num_docs
    data.fetch('response', {}).fetch('docs', []).length
  end

  def num_found
    data.fetch('response', {}).fetch('numFound', nil)
  end

  def max_score
    data.fetch('response', {}).fetch('maxScore', nil)
  end

  def doc_ids
    @doc_ids ||= docs.map { |x| x['id'] }
  end

  def retrieve_search_results!
    response = HTTP.get(request_url)

    update(response: response.body)
  end
end
