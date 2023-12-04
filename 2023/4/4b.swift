typealias Card = (win: Set<Int>, drew: Set<Int>)

func parseNumbers(_ string: String.SubSequence) -> Set<Int> {
    Set(string.split(separator: " ").map(String.init).compactMap(Int.init))
}

func readCard() -> Card? {
    guard let line = readLine() else { return nil }
    let numbers = line.split(separator: ": ")[1].split(separator: " | ")
    return (win: parseNumbers(numbers[0]), drew: parseNumbers(numbers[1]))
}

func winningNumbers(_ card: Card) -> Set<Int> {
    card.win.intersection(card.drew)
}

var copiesCounts: [Int: Int] = [:]
for cardId in 1... {
    guard let card = readCard() else { break }
    let cardCount = copiesCounts[cardId, default: 1]
    copiesCounts[cardId] = cardCount
    let score = winningNumbers(card).count
    guard score > 0 else { continue }
    for copiesCardId in cardId+1...cardId+score {
        copiesCounts[copiesCardId, default: 1] += cardCount
    }
}

let result = copiesCounts.values.reduce(0, +)
print(result)
