require "byebug"
require "prettyprint"

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

replace_symbols = ->(matrix, path) do
    matrix.each_with_index do |column, index|
        column.map.with_index do |symbol, index_2|
            if %w(| L J F 7 - S).include?(symbol) && path.find { |pipe| pipe[:column] == index && pipe[:row] == index_2 }
                matrix[index][index_2] = symbol
            else
                matrix[index][index_2] = "*"
            end
        end
    end
end

no_go_square = ->(matrix, column, row) do
    %w(| L J F 7 - S 0).include?(matrix[column][row])
end
flood_from_edge = ->(matrix, column, row) do
    return if %w(| L J F 7 - S).include?(matrix[column][row])
    matrix[column][row] = "0"
    flood_from_edge.call(matrix, column + 1, row) if column + 1 < matrix.length && !no_go_square.call(matrix, column + 1, row)
    flood_from_edge.call(matrix, column, row + 1) if row + 1 < matrix[column].length && !no_go_square.call(matrix, column, row + 1)
    flood_from_edge.call(matrix, column - 1, row) if column - 1 >= 0 && !no_go_square.call(matrix, column - 1, row)
    flood_from_edge.call(matrix, column, row - 1) if row - 1 >= 0 && !no_go_square.call(matrix, column, row - 1)
end

# Hard coded start direction
direction = "N"

path << {
    column: starting_point[:column] -1,
    row: starting_point[:row],
    symbol: matrix[starting_point[:column] -1][starting_point[:row]],
    direction: "N"
}

loop do
    begin
        next_point = find_next_point.call(path[-1], direction)
        direction = next_point[:direction]
        path << next_point
    rescue EndOfPathError
        replace_symbols.call(matrix, path)
        file = File.open("output.txt", "w")
        file.puts matrix.map { |column| column.join("") }
        break
    end
end

0.upto(matrix.length - 1) do |n|
    flood_from_edge.call(matrix, 0, n)
    flood_from_edge.call(matrix, matrix.length - 1, n)
    flood_from_edge.call(matrix, n, matrix[0].length - 1)
    flood_from_edge.call(matrix, n, 0)
end
file = File.open("output2.txt", "w")

inside_cells = []
inside = 0

# Why does this shit work???
matrix.each_with_index do |column, x|
    column.each_with_index do |symbol, y|
        next if symbol != "*"
        north, south = 0, 0
        (y..column.length - 1).each do |n|
            # Visually place S in correct array because fuck it
            if %w(J L | S).include?(matrix[x][n])
                north += 1
            end
            if %w(F 7 |).include?(matrix[x][n])
                south += 1
            end
        end
        if [north, south].min.odd?
            inside += 1
        end
    end
end

puts matrix.flatten.count { |symbol| symbol == "*" }
puts "Inside: #{inside}"