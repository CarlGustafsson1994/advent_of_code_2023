lines = File.readlines("./input.txt", chomp: true)
matched_symbol = ->(match_data, lines_to_match) do
    range_start = match_data.offset(0)[0] == 0 ? 0 : match_data.offset(0)[0] - 1
    range_end = match_data.offset(0)[1] == lines_to_match[1].length ? match_data.offset(0)[1] - 1 : match_data.offset(0)[1]
    match_range = (range_start..range_end)
    lines_to_match.reduce(false) { |acc, line| acc || !line.slice(match_range)&.tr(".", "")&.match(/\D/).nil? }
end
sum = 0
lines.each_with_index do |line, index|
    line_with_adjacent_lines = {
        previous_line: index == 0 ? "" : lines[index - 1],
        current_line: line,
        next_line: index == lines.length - 1 ? "" : lines[index + 1]
    }
    integers_in = {
        previous_line: [],
        current_line: [],
        next_line: []
    }
    line_with_adjacent_lines.each do |key, working_line|
        integers_in[key] = working_line.to_enum(:scan, /\d+/).map { Regexp.last_match }
    end
    line_sum = integers_in[:current_line].inject(0) do |acc, integer_match_data|
        acc += integer_match_data[0].to_i if matched_symbol.call(integer_match_data, line_with_adjacent_lines.values_at(:previous_line, :current_line, :next_line))
        acc
    end
    sum += line_sum
end
puts sum