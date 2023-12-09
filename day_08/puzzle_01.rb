step_loop, *instruction_list = File.readlines("./input.txt", chomp: true).reject(&:empty?).map.with_index do |line, index|
    unless index == 0
        key, left_step, right_step = line.scan(/\w{3}/)
        Hash[key, Hash["L", left_step, "R", right_step]]
    else
        line
    end
end
instruction_map = instruction_list.reduce({}, :merge)
current_location = "AAA"
steps_taken = 0
until current_location == "ZZZ"
    step_loop.each_char { |direction| steps_taken += 1; current_location = instruction_map[current_location][direction] }
end
puts steps_taken