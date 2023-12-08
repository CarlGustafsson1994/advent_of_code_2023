current_location = nil
location_range = Hash.new
lowest_number_found = Float::INFINITY
seeds = nil

File.readlines("./input.txt").each_with_index do |line, index|
    next if line.match(/^\n$/)
    seeds = line.scan(/\d+/).map(&:to_i) and next if index == 0
    possible_new_location = line.match(/\w+-\w+-\w+/).to_s
    if (possible_new_location.length > 0 && (current_location.nil? || location_range[possible_new_location].nil?))
        location_range[current_location = possible_new_location] = []
    else
        range_metrics = line.scan(/\d+/).map(&:to_i)
        location_range[current_location] << {
            "source_range" => (range_metrics[1]..(range_metrics[1] + range_metrics.last)),
            "destination_range" => (range_metrics.first..(range_metrics.first + range_metrics.last))
        }
    end
end

iteration = 0

seeds.each_slice(2).each do |seed_range_start, seed_range_length|
    puts "Iteration: #{iteration += 1} of #{seeds.length / 2}"
    seed_range = (seed_range_start..(seed_range_start + seed_range_length))
    seed_range.each do |seed|
        source = seed
        location_range.each do |_location, ranges|
            combined_ranges = ranges.find { |range_hash| range_hash["source_range"].include?(source) }
            source = combined_ranges["destination_range"].begin + (combined_ranges["source_range"].begin - source).abs unless combined_ranges.nil?
        end
        lowest_number_found = source if source < lowest_number_found
    end
end
puts lowest_number_found