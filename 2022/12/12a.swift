
func read() -> ([[Int]], (Int, Int), (Int, Int)) {
    var heights: [[Int]] = []
    var (start, end) = ((0, 0), (0,0))
    for row in (0...Int.max) {
        guard let line = readLine() else { break }
        heights.append(line.enumerated().map { column, char in
            switch char {
                case "S":
                    start = (row, column)
                    return 0
                case "E":
                    end = (row, column)
                    return 25
                default:
                    return Int(char.asciiValue ?? 0) - 97
            }
        })
    }
    return (heights, start, end)
}

let (heights, start, end) = read()
let (yRange, xRange) = (0..<heights.count, 0..<heights[0].count)

var paths = [[Int?]](repeating: [Int?](repeating: nil, count: heights[0].count), count: heights.count)
paths[start.0][start.1] = 0

var queue: [(Int, Int)] = [start]
while !queue.isEmpty {
    let index = queue.removeFirst()
    let path = paths[index.0][index.1] ?? 0
    let height = heights[index.0][index.1]
    guard path + 1 < paths[end.0][end.1] ?? Int.max else { continue }
    
    [
        (index.0 - 1, index.1),
        (index.0, index.1 + 1),
        (index.0 + 1, index.1),
        (index.0, index.1 - 1)
    ].lazy.filter {
        yRange ~= $0 && xRange ~= $1
    }.filter {
        path + 1 < paths[$0][$1] ?? .max
    }.filter {
        heights[$0][$1] <= height + 1
    }.forEach {
        paths[$0][$1] = path + 1
        queue.append(($0, $1))
    }
}

let result = paths[end.0][end.1] ?? 0
print(result)
