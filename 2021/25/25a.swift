func mod(_ n: Int, _ base: Int) -> Int { n >= 0 ? n % base : base + (n % base) }

func readGrid() -> [[Character]] {
    var lines: [String] = []
    while let line = readLine() {
        lines.append(line)
    }
    return lines.map { Array($0) }
}

var grid = readGrid()
let width = grid[0].count
let height = grid.count

class Cucumber {
    var x: Int, y: Int
    var id: Character
    var east: Int { mod(x+1, width) }
    var south: Int { mod(y+1, height) }
    
    init(_ id: Character, x: Int, y: Int) {
        self.id = id
        self.x = x
        self.y = y
    }
}

func move(_ cucumber: Cucumber, x: Int, y: Int) {
    grid[y][x] = cucumber.id
    grid[cucumber.y][cucumber.x] = "."
    cucumber.x = x
    cucumber.y = y
}

let indices = grid.indices.flatMap { y in grid[y].indices.map { (x: $0, y: y) } }
var eastCucumbers: [Cucumber] = indices.filter { grid[$0.y][$0.x] == ">" }.map { Cucumber(">", x: $0.x, y: $0.y) }
var southCucumbers: [Cucumber] = indices.filter { grid[$0.y][$0.x] == "v" }.map { Cucumber("v", x: $0.x, y: $0.y) }

for step in (1...Int.max) {
    let eastCucumbersToMove = eastCucumbers.filter { grid[$0.y][$0.east] == "." }
    eastCucumbersToMove.forEach { move($0, x: $0.east, y: $0.y) }

    let southCucumbersToMove = southCucumbers.filter { grid[$0.south][$0.x] == "." }
    southCucumbersToMove.forEach { move($0, x: $0.x, y: $0.south) }
    
    if southCucumbersToMove.isEmpty && eastCucumbersToMove.isEmpty {
        print(step)
        break
    }
}
