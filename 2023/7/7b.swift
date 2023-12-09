enum Card: Int, CaseIterable {
    case j, _2, _3, _4, _5, _6, _7, _8, _9, t, q, k, a
}

enum HandType: String {
    case fiveOfKind = "5"
    case fourOfKind = "41"
    case fullHouse = "32"
    case threeOfKind = "311"
    case twoPair = "221"
    case onePair = "2111"
    case highCard = "11111"
}

typealias Hand = [Card]
typealias Bid = (hand: Hand, handType: HandType, bid: Int)

func rawChar(_ card: Card) -> Character {
    String(describing: card).uppercased().last!
}

func card(_ _rawValue: Character) -> Card {
    Card.allCases.first { rawChar($0) == _rawValue }!
} 

func cardTypes(_ hand: Hand) -> [Card: Int] {
    [Card: [Card]](grouping: hand) { $0 }.mapValues { $0.count }
}

func handType(_ hand: Hand) -> HandType {
    let otherCards = hand.filter { $0 != .j }
    let jokersCount = 5 - otherCards.count
    if jokersCount == 5 { return .fiveOfKind }
    let counts = cardTypes(otherCards).values.sorted()
    let countsWithJokers = counts.dropLast() + [counts.last! + jokersCount]
    return HandType(
        rawValue: countsWithJokers.reversed().map(String.init).joined()
    )!
}

func areInIncreasingOrder(_ card1: Card, _ card2: Card) -> Bool {
    card1.rawValue <= card2.rawValue
}

func areInIncreasingOrder(_ type1: HandType, _ type2: HandType) -> Bool {
    type1 == type2
        || type1.rawValue.first! < type2.rawValue.first!
        || type1.rawValue.count > type2.rawValue.count
}

func areInIncreasingOrder(_ hand1: Hand, _ hand2: Hand) -> Bool {
    zip(hand1, hand2)
        .first { $0 != $1 }
        .map { areInIncreasingOrder($0, $1) } ?? true
}

func areInIncreasingOrder(_ bid1: Bid, _ bid2: Bid) -> Bool {
    bid1.handType != bid2.handType
        ? areInIncreasingOrder(bid1.handType, bid2.handType)
        : areInIncreasingOrder(bid1.hand, bid2.hand)
}

func readBid() -> Bid? {
    guard let split = readLine()?.split(separator: " ") else { return nil }
    let hand = split[0].map(card(_:)) 
    return (
        hand: hand,
        handType: handType(hand),
        bid: Int(String(split[1]))!
    )
}

func readBids() -> [Bid] {
    var bids: [Bid] = []
    while let bid = readBid() {
        bids.append(bid)
    }
    return bids
}


let result = readBids()
    .sorted(by: areInIncreasingOrder(_:_:))
    .enumerated()
    .map { $0.element.bid * ($0.offset + 1) }
    .reduce(0, +)

print(result)
