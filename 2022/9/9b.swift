
struct Index: Hashable, Equatable {	
    let x: Int, y: Int
    
    static func +(_ a: Index, _ b: Index) -> Index {
        Index(x: a.x + b.x, y: a.y + b.y)
    }
    
    static func -(_ a: Index, _ b: Index) -> Index {
        Index(x: a.x - b.x, y: a.y - b.y)
    }
}

enum Direction: String  {
    case up = "U", left = "L", right = "R", down = "D"
}

func readInstruction() -> (Direction, Int)? {
    guard let split = readLine()?.split(separator: " ").map(String.init),
    let direction = Direction(rawValue: split[0]),
    let steps = Int(split[1]) else { return nil }
    return (direction, steps)
}

func vector(direction: Direction) -> Index {
    switch direction {
        case .left: return Index(x: -1, y: 0)
        case .right: return Index(x: 1, y: 0)
        case .up: return Index(x: 0, y: 1)
        case .down: return Index(x: 0, y: -1)
    }
}

func vector(diff: Int) -> Int {
    guard diff != 0 else { return 0 }
    return diff < 0 ? 1 : -1
}

func vector(diff: Index) -> Index {
    let distance = Index(x: abs(diff.x), y: abs(diff.y))
    guard distance.x == 2 || distance.y == 2 else { return Index(x: 0, y: 0) }
    return Index(x: vector(diff: diff.x), y: vector(diff: diff.y))
}

var knots = (1...10).map { _ in Index(x: 0, y: 0) }
var visited = Set<Index>([knots[9]])

while let (direction, steps) = readInstruction() {
    for _ in 1...steps {
        knots[0] = knots[0] + vector(direction: direction)
        for index in 1...9 {
            knots[index] = knots[index] + vector(diff: knots[index] - knots[index-1])
        }
        visited.insert(knots[9])
    }
}

print(visited.count)