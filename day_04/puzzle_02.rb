lines = File.readlines("./input.txt", chomp: true)
total_scratchcards = 0
current_streak = 0

lucky_numbers = ->(line, index) do
    winning_numbers, elf_numbers = line.gsub(/Card\s+\d+\:/, "").split("|")
    number_of_matches = (winning_numbers.scan(/\d+/) & elf_numbers.scan(/\d+/)).size
    if number_of_matches > 0
        current_streak += 1
        number_of_matches.times do |n|
            lucky_numbers.call(lines[index + (n + 1)], index + (n + 1))
        end
    else
        current_streak += 1
    end
    current_streak
end

lines.each_with_index do |line, index|
    current_streak = 0
    total_scratchcards += lucky_numbers.call(line, index)
end
puts total_scratchcards