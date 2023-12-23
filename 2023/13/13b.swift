
typealias Map = [[Character]]
typealias Reflection = (index: Int, isVertical: Bool)

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

func reflectionRow(_ map: Map, skipRow: Int?) -> Int? {
    map.indices.filter { $0 > 0 && $0 != skipRow }.first { y in
        map.indices.prefix(y).allSatisfy { index in
            let distance = y-index
            let reflected = y + distance - 1
            return !(map.indices ~= reflected)
                || map[index] == map[reflected]
        }
    }
}

func reflection(_ map: Map, skip: Reflection? = nil) -> Reflection? {
    if let index = reflectionRow(
        map,
        skipRow: skip?.isVertical == true ? nil : skip?.index
    ) {
        return (index: index, isVertical: false)
    }
    if let index = reflectionRow(
        rotate(map),
        skipRow: skip?.isVertical == true ? skip?.index : nil
    ) {
        return (index: index, isVertical: true)
    }
    return nil
}

func smudgeReflection(_ map: Map)  -> (index: Int, isVertical: Bool) {
    let originalReflection = reflection(map)!
    var _map = map
    for y in map.indices {
        for x in map[y].indices {
            _map[y][x] = map[y][x] == "." ? "#" : "."
            if let reflection = reflection(_map, skip: originalReflection) {
                return reflection
            }
            _map[y][x] = map[y][x]
        }
    }
    fatalError()
}

var result = 0
while let map = readMap() {
    let reflection = smudgeReflection(map)
    result += reflection.index * (reflection.isVertical ? 1 : 100)
}
print(result)
