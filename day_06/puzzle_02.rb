time, distance = File.readlines("./input.txt").map { |line| line.scan(/\d+/).join.to_i }
p -> {(((distance / time) + 1)..time).inject(0) do |acc, potential_winning_step_length|
    acc += 1 if ((time - potential_winning_step_length) * potential_winning_step_length) > distance
    acc
end}.call