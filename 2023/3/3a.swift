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

func isSymbol(_ character: Character) -> Bool {
    let ascii = character.asciiValue ?? 0
    return ascii != 46 && !(48...57 ~= ascii)
}

func hasAdjacentSymbol(_ grid: Grid, _ index: Int) -> Bool {
    (0...2).contains { y in
        (index-1...index+1).contains { x in
            isSymbol(grid[y][x])
        }
    }
}

func partNumbers(_ grid: Grid) -> [Int] {
    var numbers: [Int] = []
    var currentNumber = 0
    var hasAnyAdjacentSymbol = false
    for x in 0..<width {
        if let digit = Int(String(grid[1][x])) {
            currentNumber = currentNumber * 10 + digit
            hasAnyAdjacentSymbol = hasAnyAdjacentSymbol || hasAdjacentSymbol(grid, x)
        } else if currentNumber != 0 {
            if hasAnyAdjacentSymbol {
                numbers.append(currentNumber)
            }
            currentNumber = 0
            hasAnyAdjacentSymbol = false
        }
    }
    return numbers
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
    result += partNumbers(grid).reduce(0, +)
    grid.remove(at: 0)
}
grid.append(emptyLine())
result += partNumbers(grid).reduce(0, +)

print(result)
