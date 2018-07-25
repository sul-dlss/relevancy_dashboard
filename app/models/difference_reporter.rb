class DifferenceReporter
  attr_reader :results

  def initialize(results)
    @results = results
  end

  def doc_rows
    transposed_data.each_with_index.map do |row, index|
      next if row.all?(&:empty?)

      current_position = results.last.doc_ids.index(row.first['id'])

      prefix = if current_position.nil?
                 nil
               else
                 index - current_position
               end
      {
        prefix: prefix,
        docs: row.map { |x| "#{x['id']}: #{x['title_245a_display']}" }
      }
    end.compact
  end

  def meta_info
    ['numFound'] + results.map do |r|
      r.data.fetch('response', {})['numFound'] || 'ERROR'
    end
  end

  def transposed_data
    results.map(&:docs).transpose
  end

  def report
    doc_rows
  end
end
