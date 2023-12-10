
func readSequences() -> [[Int]] {
    var sequences: [[Int]] = []
    while let split = readLine()?.split(separator: " ") {
        sequences.append(
            split.map(String.init).compactMap(Int.init)
        )
    }
    return sequences
}

func expand(_ sequence: [Int]) -> [Int] {
    if sequence.allSatisfy({ $0 == 0 }) {
        return sequence + [0]
    }
    let diffs = sequence.indices.dropFirst().map { index in
        sequence[index] - sequence[index-1]
    }
    let expandedDiffs = expand(diffs)
    return sequence + [sequence.last! + expandedDiffs.last!]
}

let result = readSequences()
    .map(expand(_:))
    .compactMap(\.last)
    .reduce(0, +)
print(result)
