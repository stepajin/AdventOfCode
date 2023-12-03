
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

func +(_ a: Index, _ b: Index) -> Index {
    (x: a.x + b.x, y: a.y + b.y)
}

var cave: [[Character]] = []
while let line = readLine(), !line.isEmpty {
    cave.append(Array(line))
}
let caveDimension = max(cave.count, cave.map { $0.count }.max()!)
let sideDimension = caveDimension / 4
let sideRange = 0...sideDimension-1

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

let sidesTopLefts: [Index] = [(x: 0, y: 0)] + (0...3).flatMap { row -> [Index] in
    let yRange = (row * sideDimension)...(row * sideDimension + sideDimension - 1)
    guard yRange.lowerBound < cave.count else { return [] }
    return (0...3).compactMap { col -> Index? in
        let xRange = (col * sideDimension)...(col * sideDimension + sideDimension - 1)
        guard xRange.lowerBound < cave[yRange.lowerBound].count else { return nil }
        let isEmpty = yRange.allSatisfy { y in xRange.allSatisfy{ x in cave[y][x] == " " } }
        if isEmpty { return nil }
        return (x: xRange.lowerBound, y: yRange.lowerBound)
    }
}

func caveIndex(side: Int, index: Index) -> Index {
    sidesTopLefts[side] + index
}

func rotatedCounterClockwise(_ index: Index) -> Index {
    (x: index.y, y: sideDimension-1-index.x)
}

func rotatedCounterClockwise(_ index: Index, n: Int) -> Index {
    n > 0 ? (1...n).reduce(index) { acc, _ in rotatedCounterClockwise(acc) } : index
}

let nextSideMatrix: [[Int]]
let nextSideRotatedClockwise: [[Int]]

if sideDimension == 4 {
    // sample
    
    // right, down, left, up
    nextSideMatrix = [
        /*0:*/ [],
        /*1:*/ [6, 4, 3, 2],
        /*2:*/ [3, 5, 6, 1],
        /*3:*/ [4, 5, 2, 1],
        /*4:*/ [6, 5, 3, 1],
        /*5:*/ [6, 2, 3, 4],
        /*6:*/ [1, 2, 5, 4]
    ]
    
    // right, down, left, up
    nextSideRotatedClockwise = [
        /*0:*/ [],
        /*1:*/ [2, 0, 1, 2],
        /*2:*/ [0, 2, 3, 2],
        /*3:*/ [0, 1, 0, 3],
        /*4:*/ [3, 0, 0, 0],
        /*5:*/ [0, 2, 3, 0],
        /*6:*/ [2, 1, 0, 1]
    ]
} else {
    // input
    
    // right, down, left, up
    nextSideMatrix = [
        /*0:*/ [],
        /*1:*/ [2, 3, 4, 6],
        /*2:*/ [5, 3, 1, 6],
        /*3:*/ [2, 5, 4, 1],
        /*4:*/ [5, 6, 1, 3],
        /*5:*/ [2, 6, 4, 3],
        /*6:*/ [5, 2, 1, 4]
    ]
    
    // right, down, left, up
    nextSideRotatedClockwise = [
        /*0:*/ [],
        /*1:*/ [0, 0, 2, 3],
        /*2:*/ [2, 3, 0, 0],
        /*3:*/ [1, 0, 1, 0],
        /*4:*/ [0, 0, 2, 3],
        /*5:*/ [2, 3, 0, 0],
        /*6:*/ [1, 0, 1, 0]
    ]
}

// right, down, left, up
let directionVectors: [Vector] = [
    (x: 1, y: 0),
    (x: 0, y: 1),
    (x: -1, y: 0),
    (x: 0, y: -1)
]

var currentVectorIndex = 0
var currentIndex = (x: 0, y: 0)
var currentSide = 1

for instruction in instructions {
    switch instruction {
        case .turn(let direction):
            currentVectorIndex = mod(currentVectorIndex + direction, 4)
        case .move(let steps):
            guard steps > 0 else { continue }
            for _ in 1...steps {
                let currentVector = directionVectors[currentVectorIndex]
                let tryMoveToIndex = currentIndex + currentVector
                
                if !(sideRange ~= tryMoveToIndex.y && sideRange ~= tryMoveToIndex.x) {
                    let nextSide = nextSideMatrix[currentSide][currentVectorIndex]
                    let rotations = nextSideRotatedClockwise[currentSide][currentVectorIndex]
                    let indexRotatedCounterClockwise = rotatedCounterClockwise(currentIndex, n: rotations)
                    let rotatedVectorIndex = mod(currentVectorIndex - rotations, 4)
                    let rotatedVector = directionVectors[rotatedVectorIndex]
                    let overflowIndex = (
                        x: mod(indexRotatedCounterClockwise.x + rotatedVector.x, sideDimension),
                        y: mod(indexRotatedCounterClockwise.y + rotatedVector.y, sideDimension)
                    )
                    let caveIndex = caveIndex(side: nextSide, index: overflowIndex)
                    if cave[caveIndex.y][caveIndex.x] == "#" {
                        break
                    }
                    currentSide = nextSide
                    currentIndex = overflowIndex
                    currentVectorIndex = rotatedVectorIndex
                } else {
                    let caveIndex = caveIndex(side: currentSide, index: tryMoveToIndex)
                    if cave[caveIndex.y][caveIndex.x] == "#" {
                        break
                    }
                    currentIndex = tryMoveToIndex
                }
            }
    }
}

let finalIndex = caveIndex(side: currentSide, index: currentIndex)
let password = 1000 * (finalIndex.y + 1) + 4 * (finalIndex.x + 1) + currentVectorIndex
print(password)