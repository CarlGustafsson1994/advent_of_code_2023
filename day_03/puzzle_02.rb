require "byebug"

lines = File.readlines("./input.txt", chomp: true)
matched_symbol = ->(gear_match_data, lines_to_match) do
    gear_range_start = gear_match_data.offset(0)[0] == 0 ? 0 : gear_match_data.offset(0)[0] - 1
    gear_range_end = gear_match_data.offset(0)[1]
    gear_match_range = (gear_range_start..gear_range_end)
    lines_to_match.reduce([]) do |acc, line|
        line.to_enum(:scan, /\d+/).map { Regexp.last_match }.each do |integer_match_data|
            integer_range_start = integer_match_data.offset(0)[0]
            integer_range_end = integer_match_data.offset(0)[1] - 1
            integer_match_range = (integer_range_start..integer_range_end)
            unless (gear_match_range.to_a & integer_match_range.to_a).empty?
                acc << integer_match_data[0].to_i
            end
        end
        acc
    end.compact
end
sum = 0
lines.each_with_index do |line, index|
    line_with_adjacent_lines = {
        previous_line: index == 0 ? "" : lines[index - 1],
        current_line: line,
        next_line: index == lines.length - 1 ? "" : lines[index + 1]
    }
    gear_symbol_in = {
        previous_line: [],
        current_line: [],
        next_line: []
    }
    line_with_adjacent_lines.each do |key, working_line|
        gear_symbol_in[key] = working_line.to_enum(:scan, /\d+|\*/).map { Regexp.last_match }
    end
    next unless gear_symbol_in[:current_line].map(&:to_s).include?("*")
    line_sum = gear_symbol_in[:current_line].inject(0) do |acc, gear_symbol_match_data|
        if gear_symbol_match_data[0] == "*"
            gear_numbers = matched_symbol.call(gear_symbol_match_data, line_with_adjacent_lines.values_at(:previous_line, :current_line, :next_line))
            acc += gear_numbers.inject(:*) if gear_numbers.length == 2
            acc
        else
            acc
        end
    end
    sum += line_sum
end
puts sum