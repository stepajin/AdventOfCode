
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
        return [0] + sequence
    }
    let diffs = sequence.indices.dropFirst().map { index in
        sequence[index] - sequence[index-1]
    }
    let expandedDiffs = expand(diffs)
    return [sequence[0] - expandedDiffs[0]] + sequence
}

let result = readSequences()
    .map(expand(_:))
    .compactMap(\.first)
    .reduce(0, +)
print(result)
