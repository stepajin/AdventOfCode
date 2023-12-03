typealias Pod = Character
typealias Grid = [[Pod]]
typealias Index = (x: Int, y: Int)

let hallway: [Index] = [1, 2, 4, 6, 8, 10, 11].map { (x: $0, y: 1) }
let roomX: [Pod: Int] = ["A": 3, "B": 5, "C": 7, "D": 9]
let rooms: [[Index]] = [3, 5, 7, 9].map { x in [2, 3].map { (x: x, y: $0) } }
let validIndices = hallway + rooms.flatMap { $0 }
let costs: [Pod: Int] = ["A": 1, "B": 10, "C": 100, "D": 1000]

func rooms(for pod: Pod) -> [Index] {
    rooms[Int(pod.asciiValue! - 65)]
}

func isEmpty(_ grid: Grid, _ x: Int, _ y: Int) -> Bool {
    let ascii = grid[y][x].asciiValue!
    return ascii < 65 || ascii > 68
}

func isHallway(_ index: Index) -> Bool { 
    index.y == 1 
}

func canMoveUp(_ grid: Grid, at x: Int, from y: Int) -> Bool {
    stride(from: y-1, through: 1, by: -1).allSatisfy { isEmpty(grid, x, $0) }
}

func canMoveDown(_ grid: Grid, at x: Int, to y: Int) -> Bool {
    stride(from: 2, through: y, by: 1).allSatisfy { isEmpty(grid, x, $0) }
}

func canMoveHorizontally(_ grid: Grid, from fromX: Int, to toX: Int) -> Bool {
    let direction = toX > fromX ? 1 : -1
    return stride(from: fromX + direction, through: toX, by: direction).allSatisfy { isEmpty(grid, $0, 1) }
}

func canMove(_ grid: Grid, _ pod: Pod, from: Index, to: Index) -> Bool {
    switch (isHallway(from), isHallway(to)) {
    case (true, true):
        return false
    case (true, false):
        return canMoveHorizontally(grid, from: from.x, to: to.x)
            && canMoveDown(grid, at: to.x, to: to.y)
            && canMove(grid, pod, toRoom: to)
    case (false, true):
        return canMoveUp(grid, at: from.x, from: from.y)
            && canMoveHorizontally(grid, from: from.x, to: to.x)
    case (false, false):
        return canMoveUp(grid, at: from.x, from: from.y)
            && canMoveHorizontally(grid, from: from.x, to: to.x)
            && canMoveDown(grid, at: to.x, to: to.y)
            && canMove(grid, pod, toRoom: to)
    }
}

func canMove(_ grid: Grid, _ pod: Pod, toRoom room: Index) -> Bool {
    isEmpty(grid, room.x, room.y) && (room.y == 3 || stride(from: 3, to: room.y, by: -1).allSatisfy { grid[$0][room.x] == pod })
}

func move(_ grid: Grid, _ from: Index, to: Index) -> Grid {
    var newGrid = grid
    newGrid[to.y][to.x] = newGrid[from.y][from.x]
    newGrid[from.y][from.x] = "."
    return newGrid
}

func isFinal(_ grid: Grid, _ index: Index) -> Bool {
    let pod = grid[index.y][index.x]
    guard roomX[pod]! == index.x else { return false }
    let rooms = rooms(for: pod)
    return index == rooms.last! || rooms.filter { $0.y > index.y }.allSatisfy { grid[$0.y][index.x] == pod }
}

func cost(_ pod: Pod, from: Index, to: Index) -> Int {
    let cost = costs[pod]!
    let steps = abs(from.y - 1) + abs(from.x - to.x) + abs(1 - to.y)
    return steps * cost
}

var initialGrid: Grid = (0...4).map { i in Array((readLine()! + (i >= 3 ? "  " : ""))) }

var finalGrid: Grid!
var queue: [Grid] = [initialGrid]
var minPaths: [Grid: Int] = [initialGrid: 0]

while !queue.isEmpty {
    let grid = queue.removeFirst()
    let podIndices: [Index] = validIndices.filter { !isEmpty(grid, $0.x, $0.y) && !isFinal(grid, $0) }
    
    if podIndices.isEmpty {
        finalGrid = grid
        continue
    }
    let pathCost = minPaths[grid]!
    
    for index in podIndices {
        let pod = grid[index.y][index.x]
        func tryMoveTo(_ dest: Index) {
            guard canMove(grid, pod, from: index, to: dest) else { return }
            let newGrid = move(grid, index, to: dest)
            let cost = pathCost + cost(pod, from: index, to: dest)
            guard cost < minPaths[newGrid, default: .max] else { return }
            minPaths[newGrid] = cost
            queue.append(newGrid)
        }
        hallway.forEach(tryMoveTo(_:))
        rooms(for: pod).forEach(tryMoveTo(_:))
    }
}

print(minPaths[finalGrid]!)

