typealias Map = [[Character]]

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(Array(line))
    }
    return map
}

func rotateRight(_ map: Map) -> Map {
    map[0].indices.map { x -> [Character] in
        map.indices.map { y in map[y][x] }.reversed()
    }
}

struct CacheKey: Hashable {
    let map: Map
    let rotation: Int
}
struct CacheValue {
    let map: Map
    let cycle: Int
}
var cache: [CacheKey: CacheValue] = [:]

func tilt(_ _map: Map) -> Map {
    var bottoms: [Int: Int] = [:]
    var map = _map
    for y in map.indices {
        for x in map[y].indices {
            switch map[y][x] {
                case "#":
                    bottoms[x] = y
                case "O":
                    let bottom = bottoms[x, default: -1] + 1
                    bottoms[x] = bottom
                    if map[bottom][x] == "." {
                        map[bottom][x] = "O"
                        map[y][x] = "."
                    }
                default:
                    continue
            }
        }
    }
    return map
}

var map = readMap()
let maxCycle = 1_000_000_000
var cycle = 1
while cycle <= maxCycle {
    for step in 0...3 {
        let key = CacheKey(
            map: map,
            rotation: step * 90
        )
        if let value = cache[key] {
            let loop = cycle-value.cycle
            let x = (maxCycle - cycle) / loop
            cycle += x * loop
            if cycle > maxCycle { cycle -= loop }
        }
        let tiltedMap = tilt(map)
        cache[key] = CacheValue(
            map: tiltedMap,
            cycle: cycle
        )
        map = rotateRight(tiltedMap)
    }
    cycle += 1
}

let result = map.indices.map { y in
    let weight = map.count - y
    return weight * map[y].filter { $0 == "O" }.count
}.reduce(0, +)
print(result)