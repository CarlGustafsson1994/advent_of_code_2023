lines = File.readlines("./input.txt", chomp: true)
matched_symbol = ->(offset, lines_to_match) do
    match_range = ((offset[0].zero? ? 0 : offset[0] - 1)..offset[1])
    lines_to_match.values.reduce(false) { |acc, line| acc || !line.slice(match_range)&.match(/[^.\d]/).nil? }
end
sum = 0
lines.each_with_index do |line, index|
    line_with_adjacent_lines = {
        previous_line: index.zero? ? "" : lines[index - 1],
        current_line: line,
        next_line: index == lines.length - 1 ? "" : lines[index + 1]
    }
    integers_in = Hash[line_with_adjacent_lines.map { |key, working_line| [key, working_line.to_enum(:scan, /\d+/).map { Regexp.last_match }] }]
    sum += integers_in[:current_line].inject(0) do |acc, integer_match_data|
        acc += integer_match_data[0].to_i if matched_symbol.call(integer_match_data.offset(0), line_with_adjacent_lines)
        acc
    end
end
puts sum