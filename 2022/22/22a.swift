
func mod(_ n: Int, _ m: Int) -> Int {
    let r = n % m
    return r >= 0 ? r : r + m
}

enum Instruction {
    case move(Int)
    case turn(Int)
}
typealias Index = (x: Int, y: Int)
typealias Vector = Index

var cave: [[Character]] = []
while let line = readLine(), !line.isEmpty {
    cave.append(Array(line))
}
let width = cave.map { $0.count }.max()!
let height = cave.count

let instructions: [Instruction] = readLine()!.reduce(into: []) { acc, char in
    if let int = Int(String(char)) {
        if case .move(let i) = acc.last {
            acc[acc.count-1] = .move(i * 10 + int)
        } else {
            acc.append(.move(int))
        }
    } else {
        acc.append(.turn(char == "R" ? 1 : -1))
    }
}

let xRanges: [ClosedRange<Int>] = cave.map { line in
    let left = line.firstIndex { $0 != " " }!
    let right = line.lastIndex { $0 != " " }!
    return left...right
}

let yRanges: [ClosedRange<Int>] = (0..<width).map { column in
    let top = (0..<height).first {
        guard column	 < cave[$0].count else { return false }
        return cave[$0][column] != " "
    }!
    let bottom = (0..<height).last {
        guard column	 < cave[$0].count else { return false }
        return cave[$0][column] != " "
    }!
    return top...bottom
}

let directionVectors: [Vector] = [
    (x: 1, y: 0),
    (x: 0, y: 1),
    (x: -1, y: 0),
    (x: 0, y: -1)
]

var currentVectorIndex = 0
var currentIndex: Index = (x: xRanges[0].lowerBound, y: 0)

for instruction in instructions {
    switch instruction {
        case .turn(let direction):
            currentVectorIndex = mod(currentVectorIndex + direction, 4)
        case .move(let steps):
            guard steps > 0 else { continue }
            for _ in 1...steps {
                let currentVector = directionVectors[currentVectorIndex]
                let xRange = xRanges[currentIndex.y]
                let yRange = yRanges[currentIndex.x]
                let x = mod((currentIndex.x - xRange.lowerBound) + currentVector.x, xRange.count) + xRange.lowerBound
                let y = mod((currentIndex.y - yRange.lowerBound) + currentVector.y, yRange.count) + yRange.lowerBound
                if cave[y][x] == "#" {
                    break
                }
                currentIndex = (x: x, y: y)
            }
    }
}

let password = 1000 * (currentIndex.y + 1) + 4 * (currentIndex.x + 1) + currentVectorIndex
print(password)