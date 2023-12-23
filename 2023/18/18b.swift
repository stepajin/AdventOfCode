enum Direction: Int, CaseIterable {
    case right = 0, down, left, up
}
enum LineType {
    case opening, closing
}
struct Index: Hashable {
    let x: Int, y: Int
}
struct VerticalLine {
    let x: Int
    let yRange: ClosedRange<Int>
    let type: LineType
}

typealias Instruction = (direction: Direction, length: Int)
typealias Vector = Index

func readInstruction() -> Instruction? {
    guard let split = readLine()?.split(separator: " ") else { return nil }
    let hex = String(split[2].dropFirst(2).dropLast())
    return (
        direction: Direction(rawValue: Int(String(hex.last!))!)!,
        length: Int(String(hex.prefix(5)), radix: 16)!
    )
}

func readPlan() -> [Instruction] {
    var plan: [Instruction] = []
    while let instruction = readInstruction() {
        plan.append(instruction)
    }
    return plan
}

func mod(_ a: Int, _ b: Int) -> Int {
    a < 0 ? (b-a) % b : a % b
}

func add(_ index: Index, _ vector: Vector, _ times: Int = 1) -> Index {
    Index(x: index.x + vector.x * times, y: index.y + vector.y * times)
}

func vector(_ direction: Direction) -> Vector {
    switch direction {
        case .down: Vector(x: 0, y: 1)
        case .up: Vector(x: 0, y: -1)
        case .left: Vector(x: -1, y: 0)
        case .right: Vector(x: 1, y: 0)
    }
}

func intersection(_ range: ClosedRange<Int>, _ range2: ClosedRange<Int>) -> ClosedRange<Int>? {
    let clamped = range.clamped(to: range2)
    return range.contains(clamped.lowerBound)  ? clamped : nil
}

func subtract(_ range: ClosedRange<Int>, _ range2: ClosedRange<Int>) -> (lower: ClosedRange<Int>?, upper: ClosedRange<Int>?) {
    (
        lower: range.lowerBound < range2.lowerBound
            ? range.lowerBound...range2.lowerBound-1
            : nil,
        upper: range.upperBound > range2.upperBound
            ? range2.upperBound+1...range.upperBound
            : nil
    )
}

func sort(_ lines: [VerticalLine]) -> [VerticalLine] {
    lines.sorted {
        if $0.x < $1.x { true }
        else if $0.x == $1.x { $0.yRange.lowerBound <= $1.yRange.lowerBound }
        else { false }
    }
}

func verticalLines(_ instructions: [Instruction]) -> [VerticalLine] {
    var coordinate = Index(x: 0, y: 0)
    var lines: [VerticalLine] = []
    for index in instructions.indices {
        let instruction = instructions[index]
        let vector = vector(instruction.direction)
        let prevInstruction = instructions[mod(index-1, instructions.count)]
        let nextInstruction = instructions[mod(index+1, instructions.count)]
        switch instruction.direction {
            case .up:
                var lowerBound = coordinate.y - instruction.length
                var upperBound = coordinate.y
                if nextInstruction.direction == .right { lowerBound += 1 }
                if prevInstruction.direction == .left { upperBound -= 1 }
                let line = VerticalLine(
                    x: coordinate.x,
                    yRange: lowerBound...upperBound,
                    type: .opening
                )
                lines.append(line)
            case .down:
                var lowerBound = coordinate.y
                var upperBound = coordinate.y + instruction.length
                if prevInstruction.direction == .right { lowerBound += 1 }
                if nextInstruction.direction == .left { upperBound -= 1 }
                let line = VerticalLine(
                    x: coordinate.x,
                    yRange: lowerBound...upperBound,
                    type: .closing
                )
                lines.append(line)
            case .left, .right:
                break
        }
        coordinate = add(coordinate, vector, instruction.length)
    }
    return lines
}

let instructions = readPlan()
var lines = verticalLines(instructions)
let closingLines = sort(lines.filter { $0.type == .closing })
var openingLines = sort(lines.filter { $0.type == .opening })
var innerArea = 0

while !openingLines.isEmpty {
    let leftLine = openingLines.removeFirst()
    let rightLine = closingLines
        .filter { $0.x > leftLine.x }
        .filter { intersection($0.yRange, leftLine.yRange) != nil }
        .first!
    let overlap = intersection(leftLine.yRange, rightLine.yRange)!
    let (top, bottom) = subtract(leftLine.yRange, overlap)
    if let bottom {
        let line = VerticalLine(
            x: leftLine.x,
            yRange: bottom,
            type: .opening
        )
        openingLines.insert(line, at: 0)
    }
    if let top {
        let line = VerticalLine(
            x: leftLine.x,
            yRange: top,
            type: .opening
        )
        openingLines.insert(line, at: 0)
    }
    innerArea += (rightLine.x - leftLine.x - 1) * overlap.count
}

let loopLength = instructions.map { $0.length }.reduce(0, +)
let result = loopLength + innerArea
print(result)
