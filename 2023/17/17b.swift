enum Direction: Int, CaseIterable {
    case left = 0, up, right, down
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

func rotated(_ direction: Direction, _ times: Int) -> Direction {
    Direction(rawValue: (direction.rawValue + times) % 4)!
}

struct State: Hashable {
    let index: Index
    let line: Int
    let direction: Direction
}

func heatloss(_ map: Map, start: Index, destination: Index) -> Int {
    let startState = State(index: start, line: 0, direction: .right)
    var minDestinationHeatloss = Int.max
    var queued: [State: Bool] = [:]
    var minHeatloss: [State: Int] = [startState: 0]
    var queue: [State] = [startState]

    while !queue.isEmpty {
        let state = queue.removeFirst()
        let heatloss = minHeatloss[state, default: .max]
        queued.removeValue(forKey: state)
        
        if heatloss >= minDestinationHeatloss { continue }
        
        if state.index == destination, state.line >= 4 {
            minDestinationHeatloss = min(minDestinationHeatloss, heatloss)
            continue
        }
        
        let rotations: [Int] = switch state.line {
            case 0...3: [0]
            case 4...9: [0, 1, 3]
            case 10: [1, 3]
            default: fatalError()
        }
        let directions: [Direction] = rotations.map { rotated(state.direction, $0) }
        let nextStates: [State] = directions.compactMap { direction -> State? in
            let index = add(state.index, vector(direction))
            guard map.indices ~= index.y && map[0].indices ~= index.x else { return nil }
            let state = State(
                index: index,
                line: direction == state.direction ? state.line + 1 : 1,
                direction: direction
            )
            let nextHeatloss = heatloss + map[index.y][index.x]
            if minHeatloss[state, default: .max] <= nextHeatloss { return nil }
            minHeatloss[state] = nextHeatloss
            if queued[state, default: false] { return nil }
            queued[state] = true
            return state
        }
        queue.append(contentsOf: nextStates)
    }
    
    return minDestinationHeatloss
}

let map = readMap()
let start = Index(x: 0, y: 0)
let destination = Index(x: map[0].count-1, y: map.count-1)
let result = heatloss(map, start: start, destination: destination)
print(result)
