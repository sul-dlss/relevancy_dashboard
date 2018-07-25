module ApplicationHelper
  def prefix_style(prefix)
    return '🤢' if prefix.nil?
    return if prefix.zero?
    if prefix.positive?
      content_tag 'span', "⬆︎#{prefix}", style: 'color: #998ec3'
    else
      content_tag 'span', "⬇︎#{prefix}", style: 'color: #f1a340'
    end
  end
end
