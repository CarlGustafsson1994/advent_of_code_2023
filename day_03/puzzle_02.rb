require "byebug"

lines = File.readlines("./input.txt", chomp: true)
matched_symbol = ->(gear_match_data, lines_to_match) do
    gear_range_start = gear_match_data.offset(0)[0] == 0 ? 0 : gear_match_data.offset(0)[0] - 1
    gear_range_end = gear_match_data.offset(0)[1] == lines_to_match[1].length ? gear_match_data.offset(0)[1] - 1 : gear_match_data.offset(0)[1]
    gear_match_range = (gear_range_start..gear_range_end)
    temp = [lines_to_match[0], lines_to_match[2]].reduce([]) do |acc, line|
        overlapping_number = nil
        line.to_enum(:scan, /\d+/).map { Regexp.last_match }.each do |integer_match_data|
            integer_range_start = integer_match_data.offset(0)[0]
            integer_range_end = integer_match_data.offset(0)[1]
            integer_match_range = (integer_range_start..integer_range_end)
            unless (gear_match_range.to_a & integer_match_range.to_a).empty?
                # byebug
                overlapping_number = integer_match_data[0].to_i
                acc << overlapping_number
            end
            break unless overlapping_number.nil?
        end
        acc
    end.compact
    puts "Found gear numbers: #{temp}"
    temp
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
        gear_symbol_in[key] = key == :current_line ? working_line.to_enum(:scan, /\*/).map { Regexp.last_match } : working_line.to_enum(:scan, /\d+/).map { Regexp.last_match }
    end
    next if gear_symbol_in[:current_line].empty?
    line_sum = gear_symbol_in[:current_line].inject(0) do |acc, gear_symbol_match_data|
        gear_numbers = matched_symbol.call(gear_symbol_match_data, line_with_adjacent_lines.values_at(:previous_line, :current_line, :next_line))
        acc += gear_numbers.inject(:*) if gear_numbers.length == 2
        acc
    end
    sum += line_sum
end
puts sum