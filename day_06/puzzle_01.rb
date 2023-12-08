require "byebug"

lines = File.readlines("./input.txt")
times = lines[0].scan(/\d+/).map(&:to_i)
distances = lines[1].scan(/\d+/).map(&:to_i)
races = [times, distances].transpose
number_of_ways_to_win_total = []
races.each do |time, distance|
    number_of_ways_to_win = []
    0.upto(distance).each_with_index do |potential_winning_step_length|
        number_of_ways_to_win << potential_winning_step_length if ((time - potential_winning_step_length) * potential_winning_step_length) > distance
    end
    number_of_ways_to_win_total << number_of_ways_to_win.length
end
puts number_of_ways_to_win_total.inject(:*)