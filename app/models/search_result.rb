class SearchResult < ApplicationRecord
  belongs_to :endpoint
  belongs_to :search

  def request_url
    "#{endpoint.url}?#{search.params.merge('fl' => 'id,title_245a_display,score', 'wt' => 'json', 'rows' => 20, 'debugQuery' => true, 'facet' => false).to_query}"
  end

  def data
    @data ||= JSON.parse(response)
  end

  def docs
    @docs ||= data.fetch('response', {}).fetch('docs', []).map { |doc| doc.merge('explain' => doc_explain(doc['id'])) }
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

  def doc_explain(id)
    data.fetch('debug', {}).fetch('explain', {}).fetch(id, nil)
  end

  def retrieve_search_results!
    response = HTTP.get(request_url)

    update(response: response.body)
  end
end
