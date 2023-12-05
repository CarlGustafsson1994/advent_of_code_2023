File.open("./input.txt").each_line.sum do |line|
    winning_numbers, elf_numbers = line.gsub(/Card\s+\d+\:/, "").split("|")
    lucky_numbers = winning_numbers.scan(/\d+/) & elf_numbers.scan(/\d+/)
    [0, 1].include?(lucky_numbers.size) ? lucky_numbers.size : lucky_numbers.size.times.inject(1) { |acc, n| acc = acc * 2 } / 2
end.tap { |sum| puts sum }