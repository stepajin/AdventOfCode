enum Color: String {
    case red, green, blue
}

typealias Subset = [Color: Int]
typealias Game = (id: Int, subsets: [Subset])

let totalCounts: Subset = [
    .red: 12,
    .green: 13,
    .blue: 14
]

func parseCount(_ string: String.SubSequence) -> (Color, Int) {
    let split = string.split(separator: " " ).map(String.init)
    return (Color(rawValue: split[1])!, Int(split[0])!)
}

func parseSubset(_ string: String.SubSequence) -> Subset {
    Subset(uniqueKeysWithValues: string.split(separator: ", ")
        .map(parseCount(_:)))
}

func readGame() -> Game? {
    guard let split = readLine()?.split(separator: ": ") else { return nil }
    let id = Int(split[0].split(separator: " ")[1])!
    let subsets = split[1]
        .split(separator: "; ")
        .map(parseSubset(_:))
    return (id: id, subsets: subsets)
}

func isPossible(_ subset: Subset) -> Bool {
    subset.allSatisfy { totalCounts[$0.key]! >= $0.value }
}

func isPossible(_ game: Game) -> Bool {
    game.subsets.allSatisfy(isPossible(_:))
}

var result = 0
while let game = readGame() {
    if isPossible(game) {
        result += game.id
    }
}
print(result)
