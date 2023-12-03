// Mutable array is too slow
struct Queue<T> {
    class Node<T> {
        var value: T
        var next: Node?
        init(_ value: T) {
            self.value = value
        }
    }
    var first: Node<T>?
    var last: Node<T>?
    
    mutating func enqueue(_ value: T) {
        let node = Node(value)
        last?.next = node
        last = node
        if first == nil {
            first = node
        }
    }
    
    mutating func dequeue() -> T? {
        let node = first
        first = first?.next
        if first == nil {
            last = nil
        }
        return node?.value
    }
}

func increment(_ i: Int, _ by: Int) -> Int {
    i + by < 10 ? i + by : i + by + -9
}

var risks: [[Int]] = []
while let line = readLine() {
    risks.append(line.map(String.init).compactMap(Int.init))
}
risks = risks.map { r in (0...4).flatMap { i in r.map { increment($0, i) } } }
risks = (0...4).flatMap { i in risks.map { $0.map { increment($0, i) } } }

let height = risks.count
let width = risks[0].count
var paths = [[Int]](repeating: [Int](repeating: 0, count: width), count: height)
var queue = Queue<(Int, Int)>()
queue.enqueue((0, 0))

func process(_ row: Int, _ column: Int, _ path: Int) {
    guard row >= 0 && row < height else { return }
    guard column >= 0 && column < width else { return }
    let bestPath = paths[row][column]
    let newPath = risks[row][column] + path
    if bestPath == 0 || newPath < bestPath {
        paths[row][column] = newPath
        queue.enqueue((row, column))
    }
}

while let (row, column) = queue.dequeue() {
    let path = paths[row][column]
    process(row, column-1, path)
    process(row-1, column, path)
    process(row, column+1, path)
    process(row+1, column, path)
}
print(paths.last!.last!)
