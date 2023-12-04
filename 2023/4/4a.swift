import Foundation

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

func score(_ card: Card) -> Int {
    let count = winningNumbers(card).count
    return count > 0 ? NSDecimalNumber(decimal: pow(2, count-1)).intValue : 0
}

var result = 0
while let card = readCard() {
    result += score(card)
}
print(result)
