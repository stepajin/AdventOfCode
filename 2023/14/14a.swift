typealias Map = [[Character]]

func readMap() -> Map {
    var map: Map = []
    while let line = readLine() {
        map.append(Array(line))
    }
    return map
}

var map = readMap()
var bottoms: [Int: Int] = [:]
var result = 0
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
                result += (map.count - bottom)
            default:
                continue
        }
    }
}
print(result)