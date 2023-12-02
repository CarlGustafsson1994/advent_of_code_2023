calibration_value = 0
File.open("./input.txt").each do |line|
    calibration_value += line.scan(/\d/).values_at(0, -1).join.to_i
end
puts calibration_value