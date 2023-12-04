import Foundation

typealias Line = [Character]
typealias Grid = [Line]
var width = 0

func readLine() -> Line? {
    guard let line = Swift.readLine() else { return nil }
    return Array("." + line + ".")
}

func emptyLine() -> Line {
    Line(repeating: ".", count: width)
}

func isDigit(_ character: Character) -> Bool {
    48...57 ~= character.asciiValue!
}

func readNumber(_ character: Character) -> String? {
    isDigit(character) ? String(character) : nil
}

func readNumberLeft(_ line: Line, _ maxX: Int) -> String? {
    var string = ""
    for x in (0...maxX).reversed() {
        let char = line[x]
        guard isDigit(char) else { break }
        string.insert(char, at: string.startIndex)
    }
    return string.isEmpty ? nil : string
}

func readNumberRight(_ line: Line, _ minX: Int) -> String? {
    var string = ""
    for x in minX... {
        let char = line[x]
        guard isDigit(char) else { break }
        string.append(char)
    }
    return string.isEmpty ? nil : string
}

func concatenateNumbers(left: String?, mid: String?, right: String?) -> [String] {
    [left, mid, right]
        .map { $0 ?? "," }
        .joined()
        .split(separator: ",")
        .map(String.init)
}

func adjacentNumbers(_ grid: Grid, x: Int) -> [Int] {
    let topNumbers = concatenateNumbers(
        left: readNumberLeft(grid[0], x-1),
        mid: readNumber(grid[0][x]),
        right: readNumberRight(grid[0], x+1)
    )
    let midNumbers = [
        readNumberLeft(grid[1], x-1),
        readNumberRight(grid[1], x+1)
    ].compactMap { $0 }
    let bottomNumbers = concatenateNumbers(
        left: readNumberLeft(grid[2], x-1),
        mid: readNumber(grid[2][x]),
        right: readNumberRight(grid[2], x+1)
    )
    return (topNumbers + midNumbers + bottomNumbers).compactMap(Int.init)
}

func gearsRatios(_ grid: Grid) -> [Int] {
    (0..<width)
        .filter { grid[1][$0] == "*" }
        .map { adjacentNumbers(grid, x: $0) }
        .filter { $0.count == 2 }
        .map { $0[0] * $0[1] }
}

func gearsRatiosSum(_ grid: Grid) -> Int {
    gearsRatios(grid).reduce(0, +)
}

let firstLine = readLine()!
width = firstLine.count
var grid: Grid = [
    emptyLine(),
    firstLine
]
var result = 0
while let line = readLine() {
    grid.append(line)
    result += gearsRatiosSum(grid)
    grid.remove(at: 0)
}
grid.append(emptyLine())
result += gearsRatiosSum(grid)

print(result)
