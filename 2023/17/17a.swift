enum Direction: Int {
    case up = 0, right, down, left
}
struct Index: Hashable {
    let x: Int, y: Int
}
typealias Map = [[Int]]
typealias Vector = Index

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(line.map(String.init).compactMap(Int.init))
    }
    return map
}

func add(_ index: Index, _ vector: Vector) -> Index {
    Index(x: index.x + vector.x, y: index.y + vector.y)
}

func vector(_ direction: Direction) -> Vector {
    switch direction {
        case .down: Vector(x: 0, y: 1)
        case .up: Vector(x: 0, y: -1)
        case .left: Vector(x: -1, y: 0)
        case .right: Vector(x: 1, y: 0)
    }
}

func opposite(_ direction: Direction) -> Direction {
    Direction(rawValue: (direction.rawValue + 2) % 4)!
}

func distance(_ index: Index, _ index2: Index) -> Int {
    abs(index.x - index2.x) + abs(index.y - index2.y)
}

struct State: Hashable {
    let index: Index
    let line: Int
    let direction: Direction
    let heatloss: Int
}

struct CacheKey: Hashable {
    let index: Index
    let direction: Direction
}

let allDirections: Set<Direction> = Set([.up, .left, .right, .down])
let map = readMap()
let start = Index(x: 0, y: 0)
let destination = Index(x: map.count-1, y: map[0].count-1)
var cache: [CacheKey: State] = [:]
var minHeatloss: Int = distance(start, destination) * 9

var queue: [State] = [
    State(index: start, line: 0, direction: .right, heatloss: 0)
]

while !queue.isEmpty {
    let state = queue.removeLast()
    
    if state.heatloss + distance(state.index, destination) >= minHeatloss { 
        continue
    }

    if state.index == destination {
        minHeatloss = min(minHeatloss, state.heatloss)
        continue
    }
    
    let key = CacheKey(index: state.index, direction: state.direction)
    
    if let cached = cache[key] {
        if cached.line == state.line {
            if cached.heatloss <= state.heatloss { continue }
        } else if cached.line < state.line {
            if cached.heatloss <= state.heatloss { continue }
        }
    }
    
    cache[key] = state
    
    var directions = allDirections
    directions.remove(opposite(state.direction))
    if state.line == 3 { directions.remove(state.direction) }
    let nextStates: [State] = directions.compactMap { direction -> State? in
        let vector = vector(direction)
        let index = add(state.index, vector)
        guard map.indices ~= index.y && map[0].indices ~= index.x else { return nil }
        return State(
            index: index,
            line: direction == state.direction ? state.line + 1 : 1,
            direction: direction,
            heatloss: state.heatloss + map[index.y][index.x]
        )
    }
    queue.append(contentsOf: nextStates)
}

print(minHeatloss)