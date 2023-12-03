struct Index: Hashable {
    let x, y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

func printOrigami(_ indexes: Set<Index>) {
    let maxX = indexes.map { $0.x }.max()!
    let maxY = indexes.map { $0.y }.max()!
    var origami = [[Character]](repeating: [Character](repeating: " ", count: maxX+1), count: maxY+1)
    indexes.forEach { origami[$0.y][$0.x] = "." }
    origami.forEach { print(String($0)) }
}

var indexes: Set<Index> = Set([])
var folds: [(String, Int)] = []

while let line = readLine(), !line.isEmpty {
    let values = line.split(separator: ",").map(String.init).compactMap(Int.init)
    indexes.insert(Index(values[0], values[1]))
}
while let line = readLine() {
    guard let values: [String] = line.split(separator: " ").last?.split(separator: "=").map(String.init) else { continue }
    folds.append((values[0], Int(values[1])!))
}

indexes = folds.reduce(indexes) { indexes, fold -> Set<Index> in
    Set(indexes.compactMap { index -> Index? in
        switch fold.0 {
        case "x" where index.x < fold.1,
             "y" where index.y < fold.1:
            return index
        case "x" where index.x > fold.1:
            return Index(2 * fold.1 - index.x, index.y)
        case "y" where index.y > fold.1:
            return Index(index.x, 2 * fold.1 - index.y)
        default:
            return nil
        }
    })
}
printOrigami(indexes)
