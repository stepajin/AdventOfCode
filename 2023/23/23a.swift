
enum Direction: CaseIterable {
    case left, right, up, down
}
enum Tile: Equatable {
    case space
    case tree
    case slope(Direction)
}
typealias Map = [[Tile]]

struct Index: Hashable {
    let x: Int, y: Int
}
typealias Vector = Index

func tile(_ char: Character) -> Tile {
    switch char {
        case ".": .space
        case "#": .tree
        case ">": .slope(.right)
        case "<": .slope(.left)
        case "v": .slope(.down)
        case "^": .slope(.up)
        default: fatalError()
    }
}

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(line.map(tile(_:)))
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

func tile(_ map: Map, _ index: Index) -> Tile {
    guard map.indices ~= index.y, map[0].indices ~= index.x else { return .tree }
    return map[index.y][index.x]
}

let allDirectionVectors = Direction.allCases.map(vector(_:))
func directionVectors(_ tile: Tile) -> [Vector] {
    switch tile {
        case .tree: []
        case .space: allDirectionVectors
        case .slope(let direction): [vector(direction)]
    }
}

let map = readMap()
let start = Index(x: map[0].firstIndex { $0 == .space }!, y: 0)
let destination = Index(x: map.last!.firstIndex { $0 == .space }!, y: map.endIndex-1)


struct State {
    let path: [Index]
}

func longestPath(_ start: Index, _ destination: Index) -> [Index] {
    var stack: [State] = [
        State(path: [start])
    ]
    var maxPath: [Index] = []
    while !stack.isEmpty {
        let state = stack.removeLast()
        let position = state.path.last!
        if position == destination {
            if state.path.count > maxPath.count {
                maxPath = state.path
            }
            continue
        }
        let indices = directionVectors(tile(map, position)).map {
            add(position, $0)
        }.filter {
            tile(map, $0) != .tree && !state.path.contains($0)
        }
        for index in indices {
            stack.append(State(path: state.path + [index]))
        }
    }
    return Array(maxPath.dropFirst())
}

let result = longestPath(start, destination).count
print(result)
