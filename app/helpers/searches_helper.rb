module SearchesHelper
  def render_query_params query_params
    content_tag(:span, query_params['q']) + ' ' + content_tag(:small, query_params.except('q').to_json.html_safe)
  end
end
