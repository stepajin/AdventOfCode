enum Pipe: Character {
    case bottomLeft = "7"
    case bottomRight = "F"
    case topLeft = "J"
    case topRight = "L"
    case bottomTop = "|"
    case leftRight = "-"
}

enum Tile: Equatable, Hashable {
    case pipe(Pipe), start, ground, space
}

enum Direction {
    case up, right, down, left
}

struct Index: Hashable {
    let x: Int, y: Int
}

typealias Map = [[Tile]]
typealias Path = [Index]

func tile(_ char: Character) -> Tile {
    switch char {
        case "S": .start
        case ".": .ground
        case "◦": .space
        default: .pipe(Pipe(rawValue: char)!)
    }
}

func bigTileString(_ tile: Tile) -> String {
    switch tile {
        case .ground:
            """
            ◦◦◦
            ◦.◦
            ◦◦◦
            """
        case .space:
            """
            ◦◦◦
            ◦◦◦
            ◦◦◦
            """
        case .pipe(.bottomLeft):
            """
            ◦◦◦
            -7◦
            ◦|◦
            """
        case .pipe(.bottomRight):
            """
            ◦◦◦
            ◦F-
            ◦|◦
            """
        case .pipe(.topLeft):
            """
            ◦|◦
            -J◦
            ◦◦◦
            """
        case .pipe(.topRight):
            """
            ◦|◦
            ◦L-
            ◦◦◦
            """
        case .pipe(.bottomTop):
            """
            ◦|◦
            ◦|◦
            ◦|◦
            """
        case .pipe(.leftRight):
            """
            ◦◦◦
            ---
            ◦◦◦
            """
        case .start:
            """
            ◦◦◦
            ◦S◦
            ◦◦◦
            """
    }
}

func bigTile(_ tile: Tile) -> Map {
    bigTileString(tile)
        .split(separator: "\n")
        .map { line -> [Tile] in line.map(tile(_:)) }
}

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(line.map(tile(_:)))
    }
    return map
}

func indices(_ map: Map) -> [Index] {
    map.indices.flatMap { y in 
        map[y].indices.map { Index(x: $0, y: y) }
    }
}

func adjacents(_ map: Map, _ index: Index) -> [Index] {
    [
        Index(x: index.x, y: index.y-1),
        Index(x: index.x+1, y: index.y),
        Index(x: index.x, y: index.y+1),
        Index(x: index.x-1, y: index.y),
    ].filter {
        map[index.y].indices ~= $0.x && map.indices ~= $0.y
    }
}

func tile(_ map: Map, _ index: Index) -> Tile {
    map[index.y][index.x]
}

func pipe(_ map: Map, _ index: Index) -> Pipe {
    if case let .pipe(pipe) = tile(map, index) { pipe } else { fatalError() }
}

func direction(from: Index, to: Index) -> Direction {
    if from.x < to.x { .right }
    else if from.x > to.x { .left }
    else if from.y < to.y { .down }
    else { .up }
}

func canContinue(_ map: Map, from: Index, to: Index) -> Bool {
    let direction = direction(from: from, to: to)
    guard case let .pipe(pipe) = map[to.y][to.x] else { return false }
    return switch pipe {
        case .bottomLeft:
            direction == .right || direction == .up
        case .bottomRight:
            direction == .left || direction == .up
        case .topLeft:
            direction == .right || direction == .down
        case .topRight:
            direction == .left || direction == .down
        case .bottomTop:
            direction == .up || direction == .down
        case .leftRight:
            direction == .left || direction == .right
    }
}

func move(_ index: Index, _ direction: Direction) -> Index {
    switch direction {
        case .up: Index(x: index.x, y: index.y-1)
        case .right: Index(x: index.x+1, y: index.y)
        case .down: Index(x: index.x, y: index.y+1)
        case .left: Index(x: index.x-1, y: index.y)
    }
}

func expand(_ map: Map, _ path: Path) -> Path {
    let (from, to) = (path[path.count-2], path[path.count-1])
    let (fromLeft, fromRight) = (from.x < to.x, from.x > to.x)
    let fromTop = from.y < to.y
    let nextIndex: Index = switch pipe(map, to) {
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

func pipeType(_ index: Index, from: Index, to: Index) -> Pipe {
    let fromDirection = direction(from: from, to: index)
    let toDirection = direction(from: index, to: to)
    return switch (fromDirection, toDirection) {
        case (.left, .down), (.up, .right):
            .bottomRight
        case (.right, .down), (.up, .left):
            .bottomLeft
        case (.left, .up), (.down, .right):
            .topRight
        case (.right, .up), (.down, .left):
            .topLeft
        case (.up, .up), (.down, .down):
            .bottomTop
        case (.left, .left), (.right, .right):
            .leftRight
        default:
            .bottomTop
    }
}

func enlarge(_ map: Map) -> Map {
    map.flatMap { line -> Map in
        let bigTiles: [Map] = line.map(bigTile(_:))
        return (0...2).map { y -> [Tile] in
            bigTiles.flatMap { $0[y] }
        }
    }
}

func trappedTiles(_ map: Map, _ loop: Path) -> [Index] {
    var visited = [Index: Bool](
        uniqueKeysWithValues: loop.map { ($0, true) }
    )
    var stack = [Index(x: 0, y: 0)]
    while !stack.isEmpty {
        let index = stack.removeFirst()
        guard !visited[index, default: false] else { continue }
        visited[index] = true
        stack.append(contentsOf: adjacents(map, index))
    }
    return indices(map).filter { !visited[$0, default: false] }
}


func mainLoopPath(_ map: Map, startIndex: Index) -> Path {
    let startAdjacents = adjacents(map, startIndex)
        .filter { canContinue(map, from: startIndex, to: $0) }
    var path = [startIndex, startAdjacents[0]]
    repeat {
        path = expand(map, path)
    } while path.last! != startIndex
    
    return path.dropLast()
}

var smallMap = readMap()
let startIndex: Index = indices(smallMap).first { tile(smallMap, $0) == .start }!
let startAdjacents = adjacents(smallMap, startIndex)
    .filter { canContinue(smallMap, from: startIndex, to: $0) }
let startPipe = pipeType(startIndex, from: startAdjacents[0], to: startAdjacents[1])
smallMap[startIndex.y][startIndex.x] = .pipe(startPipe)

let largeMap = enlarge(smallMap)
let largeStartIndex = Index(x: startIndex.x * 3 + 1, y: startIndex.y * 3 + 1)
let largeLoop = mainLoopPath(largeMap, startIndex: largeStartIndex)

let allTrappedTiles = trappedTiles(largeMap, largeLoop)
    .filter { tile(largeMap, $0) != .space }
let trappedPipes = allTrappedTiles.filter { index in
    if case .pipe = tile(largeMap, index) { true } else { false }
}

let result = allTrappedTiles.count - (trappedPipes.count * 2/3)
print(result)
