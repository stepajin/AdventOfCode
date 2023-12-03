extension ClosedRange where Bound == Int {
    func intersection(_ range: ClosedRange<Int>) -> ClosedRange<Int>? {
        let lowerBoundMax = Swift.max(lowerBound, range.lowerBound)
        let upperBoundMin = Swift.min(upperBound, range.upperBound)
        guard lowerBoundMax <= upperBound && lowerBoundMax <= range.upperBound 
            && upperBoundMin >= lowerBound && upperBoundMin >= range.lowerBound else { return nil }
        return lowerBoundMax...upperBoundMin
    }

    func rangeLowerThan(_ range: ClosedRange<Int>) -> ClosedRange<Int>? {
        guard lowerBound < range.lowerBound else { return nil }
        return lowerBound...range.lowerBound-1
    }

    func rangeUpperThan(_ range: ClosedRange<Int>) -> ClosedRange<Int>? {
        guard upperBound > range.upperBound else { return nil }
        return range.upperBound+1...upperBound
    }
}

struct Cuboid {
    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>
    var size: Int { x.count * y.count * z.count }
    
    func intersection(_ cuboid: Cuboid) -> Cuboid? {
        guard let x = self.x.intersection(cuboid.x),
            let y = self.y.intersection(cuboid.y),
            let z = self.z.intersection(cuboid.z) else { return nil }
        return Cuboid(x: x, y: y, z: z)
    }
    
    func cuboidsAround(_ cuboid: Cuboid) -> [Cuboid] {
        func range(_ index: Int, _ selfRange: ClosedRange<Int>, _ cuboidRange: ClosedRange<Int>) -> ClosedRange<Int>? {
            switch index {
            case 1: return selfRange.rangeLowerThan(cuboidRange)
            case 2: return cuboidRange
            case 3: return selfRange.rangeUpperThan(cuboidRange)
            default: return nil
            }
        }

        let indices = (1...3).flatMap { x in (1...3).flatMap { y in (1...3).map { z in (x, y, z) } } }
        
        return indices.compactMap { index in
            guard index != (2,2,2),
                let x = range(index.0, self.x, cuboid.x),
                let y = range(index.1, self.y, cuboid.y),
                let z = range(index.2, self.z, cuboid.z) else { return nil }
            return Cuboid(x: x, y: y, z: z)
        }
    }
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

let cuboids: [Cuboid] = steps.reduce([]) { cuboids, step in
    cuboids.flatMap { cuboid -> [Cuboid] in
        if let intersection = cuboid.intersection(step.cuboid) {
            return cuboid.cuboidsAround(intersection)
        } else {
            return [cuboid]
        }
    } + (step.instruction ? [step.cuboid] : [])
}
let size = cuboids.map { UInt64($0.size) }.reduce(0, +)
print(size)
