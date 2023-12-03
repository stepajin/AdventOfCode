import Foundation

func readPoints() -> (Int, Int, Int, Int)? {
    guard let input = readLine() else { return nil }
    let points: [Int] = input.replacingOccurrences(of: " -> ", with: ",").split(separator: ",").map(String.init).compactMap(Int.init)
    return (points[0], points[1], points[2], points[3])
}

var points: [((Int, Int, Int, Int))] = []
while let (x1, y1, x2, y2) = readPoints() {
    points.append((x1, y1, x2, y2))	
}

let maxX = points.map { max($0.0, $0.2) }.max()!
let maxY = points.map { max($0.1, $0.3) }.max()!
var grid = [[Int]](repeating: [Int](repeating: 0, count: maxX + 1), count: maxY + 1)

for (x1, y1, x2, y2) in points {
    if y1 == y2, x2 != x1 {
        stride(from: x1, through: x2, by: x2 > x1 ? 1 : -1).forEach { grid[y1][$0] += 1 }
    }
    if x1 == x2, y2 != y1 {
        stride(from: y1, through: y2, by: y2 > y1 ? 1 : -1).forEach { grid[$0][x1] += 1 }
    }
    if abs(x1 - x2) == abs(y2 - y1) && x1 != x2 {
        let xs = stride(from: x1, through: x2,  by: x2 > x1 ? 1 : -1)
        let ys = stride(from: y1, through: y2, by: y2 > y1 ? 1 : -1)
        zip(xs, ys).forEach { x, y in grid[y][x] += 1 }
    }
}

let count: Int = grid.map { $0.filter { $0 >= 2 }.count }.reduce(0, +)
print(count)
