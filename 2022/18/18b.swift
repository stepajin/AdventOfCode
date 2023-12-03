
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
var space = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 20), count: 20), count: 20)

var cubes: [Index] = []
while let (x, y, z) = readCube() {
    cubes.append((x, y, z))
    space[x][y][z] = 1
}

var queue: [Index] = []

for x in range {
    for y in range {
        for z in range {
            guard x == 0 || x == 19
                || y == 0 || y == 19
                || z == 0 || z == 19 else { continue }
            guard space[x][y][z] == 0 else { continue }
            space[x][y][z] = 2
            queue.append((x, y, z))
        }
    }
}

while !queue.isEmpty {
    let index = queue.removeFirst()
    for (x, y, z) in adjacents(index) {
        guard range ~= x, range ~= y, range ~= z else { continue }
        guard space[x][y][z] == 0 else { continue }
        space[x][y][z] = 2
        queue.append((x, y, z))
    }
}

let is2: (Int, Int, Int) -> Bool = { x, y, z in
    guard range ~= x, range ~= y, range ~= z else { return true }
    return space[x][y][z] == 2
}

let count = cubes.map {
    adjacents($0).filter(is2).count
}.reduce(0, +)

print(count)
