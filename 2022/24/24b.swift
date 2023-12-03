
struct Index: Hashable {
    let x: Int, y: Int
}
typealias Vector = Index
typealias Position = [Vector]
typealias Map = [[Position]]
typealias State = (time: Int, index: Index)

func +(_ a: Index, _ b: Index) -> Index {
    Index(x: a.x + b.x, y: a.y + b.y)
}

func distance(_ a: Index, _ b: Index) -> Int {
    abs(a.x - b.x) + abs(a.y - b.y)
}

func vector(_ char: Character) -> Vector? {
    switch char {
        case ">": return Vector(x: 1, y: 0)
        case "^": return Vector(x: 0, y: -1)
        case "v": return Vector(x: 0, y: 1)
        case "<": return Vector(x: -1, y: 0)
        case "#": return Vector(x: 0, y: 0)
        default: return nil
    }
}

func readInput() -> (start: Index, end: Index, map: Map) {
    var map: Map = []
    while let line = readLine() {
        let vectors = line.map(vector(_:))
        let positions = vectors.map { $0.map { [$0] } ?? [] }.map(Position.init)
        map.append(positions)
    }
    let start = map.first!.firstIndex { $0.isEmpty }!
    let end = map.last!.firstIndex { $0.isEmpty }!
    return (
        start: Index(x: start, y: 0),
        end: Index(x: end, y: map.count-1),
        map: map
    )
}

let (startIndex, endIndex, initialMap) = readInput()
let (height, width) = (initialMap.count, initialMap[0].count)
var maps: [Map] = [initialMap]

func move(_ map: Map) -> Map {
    var newMap = Map(repeating: [Position](repeating: [], count: width), count: height)
    for row in 0..<height {
        for column in 0..<width {
            let index = Index(x: column, y: row)
            for vector in map[row][column] {
                var move = index + vector
                if move != index {
                    move = Index(
                        x: move.x == 0 ? width - 2 : move.x == width - 1 ? 1 : move.x,
                        y: move.y == 0 ? height - 2 : move.y == height - 1 ? 1 : move.y
                    )
                }
                newMap[move.y][move.x].append(vector)
            }
        }
    }
    return newMap
}

let mapPeriod = (1...).first { _ in
    guard let previousMap = maps.last else { return false }
    let nextMap = move(previousMap)
    if nextMap == initialMap { return true }
    maps.append(nextMap)
    return false
}!

func mapIndex(_ time: Int) -> Int {
    time % mapPeriod
}

func map(time: Int) -> Map {
    maps[mapIndex(time)]
}

func hash(time: Int, index: Index) -> Int {
    struct Hash: Hashable {
        let mapIndex: Int
        let index: Index
    }
    return Hash(mapIndex: mapIndex(time), index: index).hashValue
}

let vectors: [Vector] = [
    Vector(x: 0, y: 0),
    Vector(x: 1, y: 0),
    Vector(x: -1, y: 0),
    Vector(x: 0, y: 1),
    Vector(x: 0, y: -1),
]

func isEmpty(_ index: Index, at time: Int) -> Bool {
    0..<height ~= index.y
        && 0..<width ~= index.x
        && map(time: time)[index.y][index.x].isEmpty
}

func bestTime(from startIndex: Index, to endIndex: Index, startTime: Int) -> Int {
    let initialState = State(time: startTime, index: startIndex)
    var queue: [State] = [initialState]
    var bestTime = Int.max
    var cache: [Int: Int] = [:]
    
    while !queue.isEmpty {
        let state = queue.removeFirst()
        let (time, index) = state

        if index == endIndex {
            if time < bestTime {
                bestTime = time
            }
            continue
        }
        
        if time + distance(index, endIndex) >= bestTime { 
            continue
        }
        
        let hash = hash(time: time, index: index)
        if let cachedTime = cache[hash], cachedTime <= time {
            continue
        }
        cache[hash] = time
        
        vectors
            .lazy
            .map { index + $0 }
            .filter { isEmpty($0, at: time + 1) }
            .map { (time: time + 1, index: $0) }
            .forEach { queue.append($0) }
    }
    return bestTime
}

let result = [
    (startIndex, endIndex),
    (endIndex, startIndex),
    (startIndex, endIndex)
].reduce(0) { time, indices in
    bestTime(from: indices.0, to: indices.1, startTime: time)
}

print(result)
