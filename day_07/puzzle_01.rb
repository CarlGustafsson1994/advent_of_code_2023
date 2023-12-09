CARD_RANK = "23456789TJQKA".freeze
find_type = ->(hand) do
    hand_values = hand.split("").tally.values
    case hand_values
    when -> (values) { values.length == 1 } then { name: :five_of_a_kind, score: 7 }
    when -> (values) { values.include?(4) } then { name: :four_of_a_kind, score: 6 }
    when -> (values) { ([2, 3] & values).size == 2 } then { name: :full_house, score: 5 }
    when -> (values) { values.include?(3) } then { name: :three_of_a_kind, score: 4 }
    when -> (values) { [1, 2, 2] == values.sort } then { name: :two_pair, score: 3 }
    when -> (values) { values.include?(2) } then { name: :pair, score: 2 }
    else
        { name: :high_card, score: 1 }
    end
end

hands = File.readlines("./input.txt", chomp: true).map do |line|
    hand, bid = line.split(" ")
    Hash[hand: hand, bid: bid.to_i, type: find_type.call(hand)]
end

hands.sort_by! do |hand|
    [
        hand[:type][:score],
        hand[:hand].each_char.map { |char| CARD_RANK.index(char) }
    ]
end
p -> { hands.map.with_index { |hand, index| hand[:bid] * (index + 1) }.sum }.call