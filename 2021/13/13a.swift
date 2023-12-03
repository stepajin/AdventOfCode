struct Index: Hashable {
    let x, y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

var indexes: Set<Index> = Set([])
while let line = readLine(), !line.isEmpty {
    let values = line.split(separator: ",").map(String.init).compactMap(Int.init)
    indexes.insert(Index(values[0], values[1]))
}
guard let values: [String] = readLine()?.split(separator: " ").last?.split(separator: "=").map(String.init) else { fatalError() }
let fold: (String, Int) = ((values[0], Int(values[1])!))

indexes = Set(indexes.compactMap { index -> Index? in
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
print(indexes.count)
