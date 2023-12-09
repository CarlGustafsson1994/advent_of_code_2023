CARD_RANK = "J23456789TQKA".freeze
find_type = ->(hand) do
    hand_tally = hand.split("").tally
    values = hand_tally.values
    joker_count = hand_tally["J"]
    case values
    when -> (values) { values.length == 1 || (joker_count && values.length == 2) } then { name: :five_of_a_kind, score: 7 }
    when -> (values) { values.include?(4) || (joker_count && values.any? { |value| joker_count == 2 ? values.select(&:even?).size == 2 : value + joker_count == 4 } ) }
        { name: :four_of_a_kind, score: 6 }
    when -> (values) { ([2, 3] & values).size == 2 || (values.select(&:even?).size == 2 && joker_count == 1) } then { name: :full_house, score: 5 }
    when -> (values) { values.include?(3) || (joker_count && values.include?(3 - joker_count)) } then { name: :three_of_a_kind, score: 4 }
    when -> (values) { [1, 2, 2] == values.sort || ([1, 2] == values.sort && joker_count == 1) } then { name: :two_pair, score: 3 }
    when -> (values) { values.include?(2) || (joker_count && values.length == 5) } then { name: :pair, score: 2 }
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