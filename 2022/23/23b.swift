
struct Index: Hashable {
    let x: Int, y: Int
}

typealias Vector = Index

func +(_ a: Index, _ b: Index) -> Index {
    Index(x: a.x + b.x, y: a.y + b.y)
}

var input: [String] = []
while let line = readLine() {
    input.append(line)
}

var indices: Set<Index> = Set(input.enumerated().flatMap { row, line -> [Index] in
    line.enumerated().compactMap { column, char -> Index? in
        char == "#" ? Index(x: column, y: row) : nil
    }
})

var directionVectors: [[Vector]] = [
    // North
    (-1...1).map { Vector(x: $0, y: -1) },
    // South
    (-1...1).map { Vector(x: $0, y: 1) },
    // West
    (-1...1).map { Vector(x: -1, y: $0) },
    // East
    (-1...1).map { Vector(x: 1, y: $0) }
]

let result = (1...Int.max).first { _ in
    var proposedMoves: [Index: Index] = [:]
    var proposedMovesCount: [Index: Int] = [:]
    
    for index in indices {
        let emptyDirectionVectors = directionVectors.filter {
            $0.allSatisfy { !indices.contains(index + $0) }
        }
        guard emptyDirectionVectors.count >= 1 && emptyDirectionVectors.count < 4 else {
            continue
        }
        let proposedMove = index + emptyDirectionVectors[0][1]
        proposedMoves[index] = proposedMove
        proposedMovesCount[proposedMove, default: 0] += 1
    }
    
    if !proposedMovesCount.values.contains(1) {
        return true
    }
    
    indices = Set(indices.map { index in
        if let proposedMove = proposedMoves[index], proposedMovesCount[proposedMove] == 1 {
            return proposedMove
        } else {
            return index
        }
    })
    
    directionVectors = Array(directionVectors[1...]) + [directionVectors[0]]
    return false
}!

print(result)