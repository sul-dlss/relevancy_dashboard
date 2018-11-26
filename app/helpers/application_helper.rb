module ApplicationHelper
  def position_change_style(position_change)
    return '🚫' if position_change.nil?
    return if position_change.zero?

    if position_change.positive?
      content_tag 'span', "⬆︎#{position_change}", style: 'color: #998ec3'
    else
      content_tag 'span', "⬇︎#{position_change}", style: 'color: #f1a340'
    end
  end

  def render_explain(explain)
    return unless explain.present?

    # something_useful = lambda do |key, value|
    #   if value.is_a? Hash
    #     explain.map(&something_useful)
    # end
    #
    # explain_text = explain.map(&something_useful).join("\n")
    i = 0
    navigator = lambda do |x|
      collapse_id = "collapse-#{i += 1}"

      details = if x['description']&.match?(Regexp.union(/max plus/, /sum of/))
                  Array(x['details']).sort_by { |y| y['value'] }.reverse
                else
                  Array(x['details'])
                end

      default_collapse_state = if x['description']&.match?(Regexp.union(/max plus/, /sum of/))
                                 'show'
                               else
                                 ''
                               end

      explain_class = case x['description']
                      when /weight\(/
                        'weight'
                      when /max plus/
                        'max-plus'
                      when /sum of/
                        'sum'
                      when /product of/
                        'product'
                      else
                        ''
                      end

      content_tag(:li,
                  content_tag(:span, x['value'], class: 'badge badge-default') +
                  content_tag(:span, x['description'].html_safe, data: { toggle: :collapse, target: "##{collapse_id}" }) +
                  content_tag(:ul, details.map { |y| navigator.call(y) }.join("\n").html_safe, id: collapse_id, class: "details collapse #{default_collapse_state}"),
                  class: explain_class)
    end

    if explain.is_a? Hash
      content_tag(:ul, navigator.call(explain), class: 'explain')
    else
      content_tag(:pre, explain, class: 'explain')
    end
  end
end
