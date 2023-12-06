require "byebug"
require "prettyprint"

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

seeds.each do |seed|
    mapped_source_number = seed
    location_range.each_with_index do |(location, ranges), index|
        source, destination = location.split("-to-")
        combined_ranges = ranges.find { |range_hash| range_hash["source_range"].include?(mapped_source_number) }
        unless combined_ranges.nil?
            mapped_source_number_index = combined_ranges["source_range"].find_index(mapped_source_number)
            mapped_source_number = combined_ranges["destination_range"].begin + mapped_source_number_index
        end
    end
    lowest_number_found = mapped_source_number if mapped_source_number < lowest_number_found
end
puts lowest_number_found