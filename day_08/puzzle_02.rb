step_loop, *instruction_list = File.readlines("./input.txt", chomp: true).reject(&:empty?).map.with_index do |line, index|
    unless index == 0
        key, left_step, right_step = line.scan(/\w{3}/)
        Hash[key, Hash["L", left_step, "R", right_step]]
    else
        line
    end
end

instruction_map = instruction_list.reduce({}, :merge)
starting_locations = instruction_map.keys.select { |key| key[-1] == "A" }
starting_location_hash = starting_locations.map { |location| [location, 0] }.to_h

starting_locations.each do |location|
    steps_taken = 0
    current_location = location
    until current_location[-1] == "Z"
        step_loop.each_char { |direction| steps_taken += 1; current_location = instruction_map[current_location][direction] }
    end
    starting_location_hash[location] = steps_taken
end

p starting_location_hash.map { |_key, value| value }.reduce(1) { |acc, n| acc.lcm(n) }