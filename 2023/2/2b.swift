enum Color: String, CaseIterable {
    case red, green, blue
}

typealias Subset = [Color: Int]
typealias Game = (id: Int, subsets: [Subset])

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

func maxCounts(_ game: Game) -> Subset {
    game.subsets.reduce(
        Subset(uniqueKeysWithValues: Color.allCases.map { ($0, 0) })
    ) { acc, subset in
        Subset(uniqueKeysWithValues:
            Color.allCases.map { ($0, max(acc[$0] ?? 0, subset[$0] ?? 0)) }
        )
    }
}

var result = 0
while let game = readGame() {
    result += maxCounts(game).values.reduce(1, *)
}
print(result)
