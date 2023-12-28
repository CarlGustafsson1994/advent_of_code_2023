class EndOfPathError < StandardError; end

matrix = File.readlines("input.txt", chomp: true).map { |line| line.to_enum(:split, "").map(&:to_s) }
starting_point = {
    column: matrix.index(matrix.find { |column| column.find { |row| row.include?("S") }}),
    row: matrix.find { |column| column.find { |row| row.include?("S") }}.index("S"),
    symbol: "S"
}
path = [starting_point]

find_next_point = ->(current_point, direction) do
    result = nil
    case current_point[:symbol]
    when "|" then result = direction == "S" ? 1 : -1, 0, direction
    when "L" then result = direction == "W" ? -1 : 0, direction == "S" ? 1 : 0, direction == "S" ? "E" : "N"
    when "J" then result = direction == "E" ? -1 : 0, direction == "S" ? -1 : 0, direction == "E" ? "N" : "W"
    when "F" then result = direction == "W" ? 1 : 0, direction == "N" ? 1 : 0, direction == "W" ? "S" : "E"
    when "7" then result = direction == "E" ? 1 : 0, direction == "N" ? -1 : 0, direction == "E" ? "S" : "W"
    when "-" then result = 0, direction == "E" ? 1 : -1, direction
    when "S" then raise EndOfPathError
    end
    return {
        column: current_point[:column] + result[0],
        row: current_point[:row] + result[1],
        symbol: matrix[current_point[:column] + result[0]][current_point[:row] + result[1]],
        direction: result[2]
    }
end

path << {
    column: starting_point[:column] -1,
    row: starting_point[:row],
    symbol: matrix[starting_point[:column] -1][starting_point[:row]]
}
current_point = path.last

# Hard coded start direction
direction = "N"

loop do
    begin
        next_point = find_next_point.call(current_point, direction)
        direction = next_point[:direction]
        path << next_point.slice(:column, :row, :symbol)
        current_point = path.last
    rescue EndOfPathError
        puts path.length / 2
        break
    end
end