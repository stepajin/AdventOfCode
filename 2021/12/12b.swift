enum Cave: Hashable {
    case start, end, small(String), big(String)
    init(_ s: String) {
        switch s {
        case "start": self = .start
        case "end": self = .end
        case _ where s.allSatisfy({ $0.isLowercase }): self = .small(s)
        default: self = .big(s)
        }
    }
}

var adjacentCaves: [Cave: [Cave]] = [:]
while let line = readLine()?.split(separator: "-") {
    let a = Cave(String(line[0]))
    let b = Cave(String(line[1]))
    adjacentCaves[a] = (adjacentCaves[a] ?? []) + [b]
    adjacentCaves[b] = (adjacentCaves[b] ?? []) + [a]
}

func paths(cave: Cave, visited: [Cave: Bool], revisited: Bool) -> Int {
    adjacentCaves[cave]!.map { cave -> Int in
        switch cave {
        case .end:
            return 1
        case .start:
            return 0
        case .big:
            return paths(cave: cave, visited: visited, revisited: revisited)
        case .small where visited[cave] == nil:
            var _visited = visited
            _visited[cave] = true
            return paths(cave: cave, visited: _visited, revisited: revisited)
        case .small where revisited:
            return 0
        case .small:
            return paths(cave: cave, visited: visited, revisited: true)
        }
    }.reduce(0, +)
}

let count = paths(cave: .start, visited: [:], revisited: false)
print(count)
