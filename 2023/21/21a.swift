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

func adjacents(_ map: Map, _ index: Index) -> [Index] {
    [
        Index(x: index.x-1, y: index.y),
        Index(x: index.x+1, y: index.y),
        Index(x: index.x, y: index.y-1),
        Index(x: index.x, y: index.y+1)
    ].filter {
        map.indices ~= $0.y
        && map[0].indices ~= $0.x
        && map[$0.y][$0.x]
    }
}

let (map, start) = readMap()

func indices(_ start: Index, _ distance: Int) -> Set<Index> {
    distance == 1
        ? Set(adjacents(map, start))
        : indices(start, distance-1).reduce(into: Set<Index>()) { set, index in
            set.formUnion(adjacents(map, index))
        }
}

let result = indices(start, 64).count
print(result)