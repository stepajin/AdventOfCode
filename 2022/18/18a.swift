
typealias Index = (x: Int, y: Int, z: Int)

func readCube() -> Index? {
    guard let split = readLine()?.split(separator: ",") else { return nil }
    let n = split.map(String.init).compactMap(Int.init)
    return (x: n[0], y: n[1], z: n[2])
}

func adjacents(_ index: Index) -> [Index] {
    let (x, y, z) = index
    return [
        (x-1, y, z), (x-1, y, z),
        (x, y-1, z), (x, y+1, z),
        (x, y, z-1), (x, y, z+1)
    ]
}

let range = (0...19)
var space = [[[Bool]]](repeating: [[Bool]](repeating: [Bool](repeating: false, count: 20), count: 20), count: 20)

var cubes: [Index] = []
while let cube = readCube() {
    cubes.append(cube)
    space[cube.x][cube.y][cube.z] = true
}

let isEmpty: (Int, Int, Int) -> Bool = { x, y, z in
    guard range ~= x, range ~= y, range ~= z else { return true }
    return !space[x][y][z]
}

let count = cubes.map {
    adjacents($0).filter(isEmpty).count
}.reduce(0, +)

print(count)
