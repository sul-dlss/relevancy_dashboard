class DifferenceReporter
  attr_reader :results

  def initialize(results)
    @results = results
  end

  def doc_rows
    @doc_rows ||= transposed_data.each_with_index.map do |row, index|
      next if row.all?(&:empty?)

      current_position = results.last.doc_ids.index((row.first || {})['id'])

      prefix = if current_position.nil?
                 nil
               else
                 index - current_position
               end
      {
        originalPosition: index || 0,
        originalScore: (row.first || {})['score'] || 0,
        positionChange: prefix,
        docs: row
      }
    end.compact
  end

  # The change score is a metric for how different the two search result sets are, taking into
  # account both recall and how the first page of documents are ranked. Higher scores mean
  # the results are more different.
  #
  # Assumptions:
  # - search results with low recall but high varience in relevancy are interesting
  # - search results with high recall are not as interesting
  # - the first few results changing is more interesting than the long tail
  # - documents with an almost indistinguishable score compared to its neighbors moving around a little bit isn't interesting
  def change_score
    return 0 unless doc_rows.many?

    score = 0
    doc_rows.each_with_index do |row, index|
      # if positionChange is nil, it's because it has fallen off the first page
      change = row[:positionChange] || 25

      # if the document is in the same place, I guess we don't care..
      next if change.zero?

      # use the difference in relevancy scores to temper the position change; if there wasn't a lot of difference between
      # them, the position change shouldn't matter as much
      next_score = (doc_rows[index + 1] || { originalScore: doc_rows.last[:originalScore] })[:originalScore]
      weighted_delta_score = Math.sqrt(1 + (row[:originalScore] - next_score)) - 0.99

      # weight the position change against where it originally appeared, so a #1 document has a larger impact
      # than the #20 document.
      position_change_score = change.abs / Math.sqrt(1 + row[:originalPosition])

      # temper the position change with the relevancy delta information
      score += weighted_delta_score * position_change_score
    end
    # if the original relevancy score was high, the differences matter more; low-quality searches probably had
    # bad results anyway..
    score *= Math.log(1 + baseline_max_score)

    # finally, punish recall failures, weighted so small result sets changing a little have a bigger impact
    # than a large result set changing a little.
    score += 100 * Math.log(1 + num_found_difference / (results.first.num_found + 0.0001))
  end

  def baseline_max_score
    @baseline_max_score ||= results.first.max_score
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
    results.map do |x|
      docs = x.docs
      docs.fill({}, docs.length, num_docs - docs.length)
    end.transpose
  end

  def report
    doc_rows
  end

  def num_docs
    results.map(&:num_docs).max
  end
end
