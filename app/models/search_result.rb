class SearchResult < ApplicationRecord
  belongs_to :endpoint
  belongs_to :search

  def request_url
    "#{endpoint.url}?#{search_params.to_query}"
  end

  def search_params
    search.params.merge('fl' => 'id,title_245a_display,score', 'wt' => 'json', 'rows' => 20, 'debugQuery' => true, 'facet' => false)
  end

  def explain_url(id = nil)
    "#{endpoint.url}?#{search_params.merge('debug.explain.structured' => true, 'explainOther' => "id:#{id || '__undefined__'}").to_query}"
  end

  def data
    @data ||= JSON.parse(response)
  end

  def docs
    @docs ||= data.fetch('response', {}).fetch('docs', []).map { |doc| doc.merge('search_result' => self) }
  end

  def num_docs
    data.fetch('response', {}).fetch('docs', []).length
  end

  def num_found
    data.fetch('response', {}).fetch('numFound', 0)
  end

  def max_score
    data.fetch('response', {}).fetch('maxScore', 0)
  end

  def doc_ids
    @doc_ids ||= docs.map { |x| x['id'] }
  end

  def doc_explain(id)
    fetch_doc_explain(id)
  end

  def fetch_doc_explain(id)
    explain = JSON.parse(HTTP.timeout(write: 2, connect: 5, read: 10).get(explain_url(id)).body)
    explain.fetch('debug', {}).fetch('explainOther', {}).fetch(id, nil)
  end

  def retrieve_search_results!
    response = HTTP.get(request_url)

    update(response: response.body)
  end
end
