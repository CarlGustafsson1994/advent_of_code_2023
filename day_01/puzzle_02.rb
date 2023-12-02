transformation_hash = {
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9",
}
matching_regex_1 = /\d|#{transformation_hash.keys.join("|")}/
matching_regex_2 = /.*(\d|#{transformation_hash.keys.join("|")}).*$/
File.open("./input.txt").each_line.sum do |line|
    first_match = line[matching_regex_1]
    second_match = line[matching_regex_2, 1]
    [transformation_hash[first_match] || first_match, transformation_hash[second_match] || second_match].join.to_i
end.tap { |sum| puts sum }