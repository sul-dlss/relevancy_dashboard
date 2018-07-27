class DifferenceReporter
  attr_reader :results

  def initialize(results)
    @results = results
  end

  def doc_rows
    @doc_rows ||= transposed_data.each_with_index.map do |row, index|
      next if row.all?(&:empty?)

      current_position = results.last.doc_ids.index(row.first['id'])

      prefix = if current_position.nil?
                 nil
               else
                 index - current_position
               end
      {
        originalPosition: index,
        positionChange: prefix,
        docs: row
      }
    end.compact
  end

  def change_score
    score = 0
    doc_rows.each do |row|
      change = row[:positionChange] || 20
      score +=  change.abs / Math.log(row[:originalPosition] + 2)
    end
    (score + Math.log(1 + num_found_difference)) * Math.log(1 + baseline_max_score)
  end

  def baseline_max_score
    results.first.max_score
  end

  def num_found_difference
    results.map(&:num_found).inject(:-).abs
  end

  def meta_info
    ['numFound'] + results.map do |r|
      r.data.fetch('response', {})['numFound'] || 'ERROR'
    end
  end

  def transposed_data
    results.map { |x| x.docs.fill({}, num_docs, 20 - num_docs) }.transpose
  end

  def report
    doc_rows
  end

  def num_docs
    results.first.num_docs
  end
end
