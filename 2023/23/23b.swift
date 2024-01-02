
enum Direction: Int, CaseIterable {
    case left = 0, up, right,  down
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

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(line.map(tile(_:)))
    }
    return map
}

func tile(_ char: Character) -> Tile {
    switch char {
        case ".": .space
        case "#": .tree
        default: .space
    }
}

func opposite(_ direction: Direction) -> Direction {
    Direction(rawValue: (direction.rawValue + 2) % 4)!
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

func directions(_ map: Map, _ index: Index) -> [Direction] {
    Direction.allCases.filter {
        tile(map, add(index, vector($0))) == .space
    }
} 

let map = readMap()
let start = Index(x: map[0].firstIndex { $0 == .space }!, y: 0)
let destination = Index(x: map.last!.firstIndex { $0 == .space }!, y: map.endIndex-1)
var crossroads: Set<Index> = [start, destination]
for y in map.indices {
    for x in map[y].indices {
        let index = Index(x: x, y: y)
        guard tile(map, index) == .space else { continue }
        if directions(map, index).count > 2 { crossroads.insert(index) }
    }
}

struct Exit: Hashable {
    let crossroad: Index
    let direction: Direction
}
typealias NextCrossroad = (crossroad: Index, path: Int)

func crossroadMap(_ map: Map, _ crossroads: Set<Index>) -> [Exit: NextCrossroad] {
    struct State: Hashable {
        let start: Exit
        let path: Int
        let position: Index
        let direction: Direction
    }
    var crossroardsMap: [Exit: (Index, Int)] = [:]
    var stack: [State] = [
        State(
            start: Exit(crossroad: start, direction: .down),
            path: 0,
            position: start,
            direction: .down
        )
    ]
    while !stack.isEmpty {
        let state = stack.removeLast()
        if crossroardsMap[state.start] != nil { continue }
        let nextPosition = add(state.position, vector(state.direction))
        let oppositeDirection = opposite(state.direction)
        let nextDirections = directions(map, nextPosition)
            .filter { $0 != oppositeDirection }
        if crossroads.contains(nextPosition) {
            crossroardsMap[state.start] = (crossroad: nextPosition, path: state.path)
            let oppositeExit = Exit(crossroad: nextPosition, direction: oppositeDirection)
            crossroardsMap[oppositeExit] = (crossroad: state.start.crossroad, path: state.path)
            for direction in nextDirections {
                stack.append(
                    State(
                        start: Exit(crossroad: nextPosition, direction: direction),
                        path: 0,
                        position: nextPosition,
                        direction: direction
                    )
                )
            }
        } else {
            if nextDirections.isEmpty { continue }
            stack.append(
                State(
                    start: state.start,
                    path: state.path+1,
                    position: nextPosition,
                    direction: nextDirections[0]
                )
            )
        }
    }
    return crossroardsMap
}

let crossroadsMap = crossroadMap(map, crossroads)
let maxSteps = [Index: Int](uniqueKeysWithValues: 
    crossroads.map { crossroad in (crossroad, 
        crossroadsMap
        .filter { $0.key.crossroad == crossroad }
        .map { $0.value.path }
        .max()!
    )}
)

struct State {
    let crossroad: Index
    let remaining: Set<Index>
    let path: Int
}

var stack: [State] = [State(
    crossroad: start,
    remaining: crossroads.subtracting([start]),
    path: 0
)]
var maxPath = Int.min

while !stack.isEmpty {
    let state = stack.removeLast()
    if state.crossroad == destination {
        if state.path > maxPath {
            print(state.path)
        }
        maxPath = max(maxPath, state.path)
        continue
    }

    let maxSubpathSum = state.remaining.map({ maxSteps[$0]! }).reduce(0, +)
    if state.path + state.remaining.count + maxSubpathSum < maxPath { continue }
    
    let nextStates = Direction.allCases.compactMap {
        crossroadsMap[Exit(crossroad: state.crossroad, direction: $0)]
    }.filter {
        state.remaining.contains($0.crossroad)
    }.map {
        State(
            crossroad: $0.crossroad,
            remaining: state.remaining.subtracting([$0.crossroad]),
            path: state.path + 1 + $0.path
        )
    }
    stack.append(contentsOf: nextStates)
}

