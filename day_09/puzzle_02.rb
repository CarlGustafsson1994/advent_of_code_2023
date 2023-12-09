calculate_next_number = ->(acc, series) do
    if series.all?(&:zero?)
        acc << series.each_cons(2).map { |a, b| b - a }
    else
        calculate_next_number.call(acc << series, series.each_cons(2).map { |a, b| b - a })
    end
end
index = 0
p -> do
    File.open("./input.txt", chomp: true).each_line.sum do |line|
        index += 1
        starting_series = line.scan(/-?\d*\.{0,1}\d+/).map(&:to_i)
        result = calculate_next_number.call([], starting_series)
        current_addition = 0
        (result.compact << [0]).reverse.each_cons(2) do |a, b|
            result[result.index(b)].unshift(b.first - a.first)
        end
        result[0][0]
    end
end.call
