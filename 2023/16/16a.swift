enum Direction {
    case up, down, right, left
}
struct Index: Hashable {
    let x: Int, y: Int
}
typealias Map = [[Character]]
typealias Vector = Index

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(Array(line))
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

func next(_ map: Map, _ index: Index, _ direction: Direction) -> [Direction] {
    switch (map[index.y][index.x], direction) {
        case ("\\", .up): [.left]
        case ("\\", .right): [.down]
        case ("\\", .down): [.right]
        case ("\\", .left): [.up]
        case ("/", .up): [.right]
        case ("/", .right): [.up]
        case ("/", .down): [.left]
        case ("/", .left): [.down]
        case ("|", .up), ("|", .down): [direction]
        case ("|", .right), ("|", .left): [.up, .down]
        case ("-", .left), ("-", .right): [direction]
        case ("-", .up), ("-", .down): [.left, .right]
        case (".", _): [direction]
        default: {
            print(map[index.y][index.x], direction); 
            fatalError()
        }()
            
            
    }
}

struct State: Hashable {
    let index: Index
    let direction: Direction
}

func energize( _ map: Map) -> Int {
    var visited: [State: Bool] = [:]
    var energized: [Index: Bool] = [:]
    
    var queue: [State] = [State(index: Index(x: 0, y: 0), direction: .right)]
    while !queue.isEmpty {
        let state = queue.removeFirst()
        energized[state.index] = true
        if visited[state, default: false] { continue }
        visited[state] = true
        queue.append(contentsOf: next(map, state.index, state.direction).compactMap { direction in
            let index = add(state.index, vector(direction))
            guard map.indices ~= index.y && map[0].indices ~= index.x else { return nil }
            return State(
                index: index,
                direction: direction
            )
        })
    }
    return energized.keys.count
}


let map = readMap()
let result = energize(map)
print(result)
