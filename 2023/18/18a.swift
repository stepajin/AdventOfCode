enum Direction: Character, CaseIterable {
    case left = "L", up = "U", right = "R", down = "D"
}
struct Index: Hashable {
    let x: Int, y: Int
}
typealias Instruction = (direction: Direction, length: Int)
typealias Vector = Index

func readInstruction() -> Instruction? {
    guard let split = readLine()?.split(separator: " ").map(String.init) else { return nil }
    return (direction: Direction(rawValue: split[0].first!)!, length: Int(split[1])!)
}

func readPlan() -> [Instruction] {
    var plan: [Instruction] = []
    while let instruction = readInstruction() {
        plan.append(instruction)
    }
    return plan
}

func add(_ index: Index, _ vector: Vector) -> Index {
    Index(x: index.x + vector.x, y: index.y + vector.y)
}

func vector(_ direction: Direction) -> Vector {
    switch direction {
        case .down: Vector(x: 0, y: 1)
        case .up: Vector(x: 0, y: -1)
        case .left: Vector(x: -1, y: 0)
        case .right: Vector(x: 1, y: 0)
    }
}

var index = Index(x: 0, y: 0)
var loop: [Index: Bool] = [index: true]
var exterior: [Index: Bool] = [:]

for instruction in readPlan() {
    let vector = vector(instruction.direction)
    let indices = (1...instruction.length).map {
        Index(x: index.x + $0 * vector.x, y: index.y + $0 * vector.y)
    }
    indices.forEach { loop[$0] = true }
    index = indices.last!
}

let xIndices = loop.keys.map { $0.x }.sorted()
let yIndices = loop.keys.map { $0.y }.sorted()
let xRange = (xIndices.first!...xIndices.last!)
let yRange = (yIndices.first!...yIndices.last!)
let directionVectors = Direction.allCases.map(vector(_:))

var queue: [Index] = []
xIndices.forEach { x in
    queue.append(Index(x: x, y: yRange.upperBound))
    queue.append(Index(x: x, y: yRange.lowerBound))
}
yIndices.dropFirst().dropLast().forEach { y in
    queue.append(Index(x: xRange.lowerBound, y: y))
    queue.append(Index(x: xRange.upperBound, y: y))
}

while !queue.isEmpty {
    let index = queue.removeFirst()
    guard xRange ~= index.x && yRange ~= index.y else { continue }
    if loop[index, default: false] || exterior[index, default: false] { continue }
    exterior[index] = true
    queue.append(contentsOf: directionVectors.map { add(index, $0) })
}

let result = (xRange.count * yRange.count) - exterior.keys.count
print(result)

