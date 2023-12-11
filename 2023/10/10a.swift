enum Pipe: Character {
    case bottomLeft = "7"
    case bottomRight = "F"
    case topLeft = "J"
    case topRight = "L"
    case bottomTop = "|"
    case leftRight = "-"
}

enum Tile: Equatable {
    case pipe(Pipe)
    case start
    case ground
}

enum Direction {
    case up, right, down, left
}

typealias Map = [[Tile]]
typealias Index = (x: Int, y: Int)
typealias Path = [Index]

func tile(_ char: Character) -> Tile {
    char == "S"
        ? .start
        : Pipe(rawValue: char).map { Tile.pipe($0) }
            ?? .ground
}

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(line.map(tile(_:)))
    }
    return map
}

let map = readMap()

func adjacents(_ index: Index) -> [Index] {
    [
        (x: index.x, y: index.y-1),
        (x: index.x+1, y: index.y),
        (x: index.x, y: index.y+1),
        (x: index.x-1, y: index.y),
    ].filter {
        map.indices ~= $0.x && map.indices ~= $0.y
    }
}

func tile(_ index: Index) -> Tile {
    map[index.y][index.x]
}

func pipe(_ index: Index) -> Pipe {
    guard case let .pipe(pipe) = tile(index) else { fatalError() }
    return pipe
}

func canContinue(from: Index, to: Index) -> Bool {
    guard case let .pipe(pipe) = map[to.y][to.x] else { return false }
    return switch pipe {
        case .bottomLeft: to.y < from.y && to.x < from.x
        case .bottomRight: to.y < from.y && to.x > from.x
        case .topLeft: to.y > from.y && to.x < from.x
        case .topRight: to.y > from.y && to.x > from.x
        case .bottomTop: to.y != from.y && to.x == from.x
        case .leftRight: to.y == from.y && to.x != from.x
    }
}

func move(_ index: Index, _ direction: Direction) -> Index {
    switch direction {
        case .up: (x: index.x, y: index.y-1)
        case .right: (x: index.x+1, y: index.y)
        case .down: (x: index.x, y: index.y+1)
        case .left: (x: index.x-1, y: index.y)
    }
}

func expand(_ path: Path) -> Path {
    let (from, to) = (path[path.count-2], path[path.count-1])
    let (fromLeft, fromRight) = (from.x < to.x, from.x > to.x)
    let fromTop = from.y < to.y
    let nextIndex = switch pipe(to) {
        case .bottomLeft:
            fromLeft ? move(to, .down) : move(to, .left)
        case .bottomRight:
            fromRight ? move(to, .down) : move(to, .right)
        case .topLeft:
            fromLeft ? move(to, .up) : move(to, .left)
        case .topRight:
            fromRight ? move(to, .up) : move(to, .right)
        case .bottomTop:
            fromTop ? move(to, .down) : move(to, .up)
        case .leftRight:
            fromLeft ? move(to, .right) : move(to, .left)
    }
    return path + [nextIndex]
}

let startIndex: Index = map.indices
    .flatMap { y in map.indices.map { (x: $0, y: y) } }
    .first { tile($0) == .start }!

let secondIndex = adjacents(startIndex)
    .first { canContinue(from: startIndex, to: $0) }!
var path = [startIndex, secondIndex]

repeat {
    path = expand(path)
} while path.last! != startIndex

let pipeCount = path.count - 2
let result = pipeCount % 2 == 0
    ? pipeCount / 2
    : pipeCount / 2 + 1
    
print(result)