
typealias Map = [[Character]]

func readMap() -> Map? {
    var map: Map = []
    while let line = readLine(), !line.isEmpty {
        map.append(Array(line))
    }
    return map.isEmpty ? nil : map
}

func rotate(_ map: Map) -> Map {
    map[0].indices.map { x -> [Character] in
        map.indices.map { y in
            map[y][x]
        }
    }
}

func reflectionIndex(_ map: Map) -> Int? {
    map.indices.dropFirst().first { y in
        map.indices.prefix(y).allSatisfy { index in
            let distance = y-index
            let reflected = y + distance - 1
            return !(map.indices ~= reflected)
                || map[index] == map[reflected]
        }
    }
}

func reflection(_ map: Map) -> (index: Int, isVertical: Bool) {
    if let index = reflectionIndex(map) {
        return (index: index, isVertical: false)
    }
    if let index = reflectionIndex(rotate(map)) {
        return (index: index, isVertical: true)
    }
    fatalError()
}

var result = 0
while let map = readMap() {
    let reflection = reflection(map)
    result += reflection.index * (reflection.isVertical ? 1 : 100)
}
print(result)
