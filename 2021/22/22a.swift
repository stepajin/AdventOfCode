struct Cuboid {
    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>
}

typealias Step = (instruction: Bool, cuboid: Cuboid)

func parseRange(_ raw: String) -> ClosedRange<Int> {
    let range = raw.split(separator: "=")[1].split(separator: ".").map(String.init).compactMap(Int.init)
    return range[0]...range[1]
}

func parseCuboid(_ raw: String) -> Cuboid {
    let ranges = raw.split(separator: ",").map(String.init).map(parseRange(_:))
    return Cuboid(x: ranges[0], y: ranges[1], z: ranges[2])
}

func parseStep(_ raw: String) -> Step {
    let split = raw.split(separator: " ").map(String.init)
    return (instruction: split[0] == "on", cuboid: parseCuboid(split[1]))
}

var steps: [Step] = []
while let line = readLine() {
    steps.append(parseStep(line))
}

func index(_ x: Int, _ y: Int, _ z: Int) -> Int {
    (x + 50) * 10201 + (y + 50) * 101 + (z + 50)
}

var cubes = [Bool](repeating: false, count: 1030301)

for s in steps {
    for x in s.cuboid.x where x >= -50 && x <= 50 {
        for y in s.cuboid.y where y >= -50 && y <= 50 {
            for z in s.cuboid.z where z >= -50 && z <= 50 {
                cubes[index(x, y, z)] = s.instruction
            }
        }
    }
}

print(cubes.lazy.filter { $0 }.count)