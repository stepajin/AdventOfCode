struct Index: Hashable {
    let x: Int, y: Int
}
typealias Tile = Bool
typealias Map = [[Tile]]

func readMap() -> (map: Map, start: Index) {
    var map: Map = []
    var start = Index(x: 0, y: 0)
    for y in 0... {
        guard let line = readLine() else { break }
        map.append(line.enumerated().map { x, char in
            switch char {
                case ".":
                    return true
                case "S":
                    start = Index(x: x, y: y)
                    return true
                default:
                    return false
            }
        })
    }
    return (map: map, start: start)
}

func mod(_ a: Int, _ b: Int) -> Int {
    (a % b + b) % b
}

func adjacents(_ index: Index) -> [Index] {
    [
        Index(x: index.x-1, y: index.y),
        Index(x: index.x+1, y: index.y),
        Index(x: index.x, y: index.y-1),
        Index(x: index.x, y: index.y+1)
    ]
}

func tile(_ map: Map, _ index: Index) -> Tile {
    map[mod(index.y, map.count)][mod(index.x, map[0].count)]
}

struct State: Hashable {
    let index: Index
    let mod: Int
}

func reachable(_ map: Map, _ start: Index, _ distance: Int) -> Int {
    var visited: Set<State> = [State(index: start, mod: 0)]
    var indices: Set<Index> = [start]
    for i in 1...distance {
        var _indices: Set<Index> = []
        for index in indices {
            for adjacent in adjacents(index) where tile(map, adjacent) {
                let state = State(index: adjacent, mod: i & 1)
                if visited.contains(state) { continue }
                visited.insert(state)
                _indices.insert(adjacent)
            }
        }
        indices = _indices
    }
    let res = visited
        .filter { $0.mod == distance & 1 }
        .map { $0.index }
        .reduce(into: Set<Index>()) { $0.insert($1) }
    return res.count
}

let (map, start) = readMap()
let width = map[0].count
let steps = 26501365
let cycleNumber = (steps - (width/2)) / width

var sequence = [Int]()
sequence.reserveCapacity(cycleNumber+1)
for i in 0...2 {
    sequence.append(reachable(map, start, width/2 + i * width))
}
let diff = (sequence[2] - sequence[1]) - (sequence[1] - sequence[0])
for i in 3...cycleNumber {
    sequence.append(sequence[i-1] + (sequence[i-1]-sequence[i-2]) + diff)
}

let result = sequence[cycleNumber]
print(result)
