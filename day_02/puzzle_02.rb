File.open("./input.txt").each_line.sum do |line|
    partitioned_sets = line.scan(/\d+\sblue|\d+\sgreen|\d+\sred/)
                           .sort_by { |set| [set[/blue|green|red/], set[/\d+/].to_i] }
                           .group_by { |set| set[/blue|green|red/] }
    partitioned_sets["blue"][-1][/\d+/].to_i*partitioned_sets["green"][-1][/\d+/].to_i*partitioned_sets["red"][-1][/\d+/].to_i
end.tap { |sum| puts sum }