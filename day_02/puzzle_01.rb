color_limit_lambda = ->(set) { set[/blue/] ? 14 : set[/green/] ? 13 : 12 }
File.open("./input.txt").reject do |line|
    line.scan(/\d+\sblue|\d+\sgreen|\d+\sred/).any? { |set| set[/\d+/].to_i > color_limit_lambda.call(set) }
end.map { |set| set[/Game\s\d+/][-2..-1].to_i }.sum.tap { |sum| puts sum }