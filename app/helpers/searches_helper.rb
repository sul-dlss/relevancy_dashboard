module SearchesHelper
  def render_query_params query_params
    "#{render_q_param(query_params.fetch('q', '(no q parameter given)'))} #{content_tag(:small, query_params.to_json.html_safe)}"
  end

  def render_q_param(q)
    patterns = {
      '{!pf2=$p2 pf3=$pf3}' => 'Keyword',
      '{!qf=author_title_search pf=author_title_search^10 pf3=author_title_search^5 pf2=author_title_search^2}' => 'Author/Title',
      '{!qf=$qf_author pf=$pf_author pf3=$pf3_author pf2=$pf2_author}' => 'Author',
      '{!qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject}' => 'Subject',
      '{!qf=$qf_series pf=$pf_series pf3=$pf3_series pf2=$pf2_series}' => 'Series',
      '{!qf=$qf_title pf=$pf_title pf3=$pf3_title pf2=$pf2_title}' => 'Title',
      '{!qf=$qf_cjk pf=$pf_cjk pf3=$pf3_cjk pf2=$pf2_cjk}' => 'CJK Keyword'
    }

    sanitized_q = q.gsub(Regexp.union(patterns.keys)) do |match|
      "#{content_tag(:strong, patterns[match])}: "
    end

    content_tag(:div, sanitized_q.html_safe)
  end
end
