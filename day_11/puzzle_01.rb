n = (1..).to_enum
input = File.foreach("./input.txt", chomp: true).map { |line| line.chars.map { |char| char == "#" ? n.next : char } }

input.map! do |line|
    line.any? { |char| char.is_a?(Integer) } ? line : line.map { |char| ".." }
end
input = input.transpose.map do |line|
    line.any? { |char| char.is_a?(Integer) } ? line : line.map { |char| ".." }
end.transpose

sum = 0
find_galaxy_coordinates = -> (galaxy) do
    coordinates = nil
    double_steps_passed_y = 0
    input.each_with_index do |line, y|
        double_steps_passed_x = 0
        double_steps_passed_y += 1 if line.all? { |char| char == ".." }
        line.each_with_index do |char, x|
            double_steps_passed_x += 1 if char == ".."
            coordinates = [x + double_steps_passed_x, y + double_steps_passed_y] and break if char == galaxy
        end
    end
    coordinates
end
1.upto(n.peek - 1) do |galaxy|
    puts "Iteration #{galaxy} of #{n.peek - 1}"
    1.upto(n.peek - 1) do |other_galaxies|
        next if other_galaxies <= galaxy
        current_galaxy_coordinates = find_galaxy_coordinates.call(galaxy)
        next_galaxy_coordinates = find_galaxy_coordinates.call(other_galaxies)
        distance = (next_galaxy_coordinates[0] - current_galaxy_coordinates[0]).abs + (next_galaxy_coordinates[1] - current_galaxy_coordinates[1]).abs
        sum += distance
    end
end
puts sum