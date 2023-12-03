typealias Index = (x: Int, y: Int)

func stride(_ from: Int, _ through: Int) -> StrideThrough<Int> {
    stride(from: from, through: through, by: from < through ? 1 : -1)
}

func readPath() -> [Index]? {
    guard let split = readLine()?
        .split(separator: " -> ") else { return nil }
    return split
        .map { $0.split(separator: ",").map(String.init).compactMap(Int.init) }
        .map { (x: $0[0], y: $0[1]) }
}

var paths: [[Index]] = []
while let path = readPath() { paths.append(path) }

let points = [(500, 0)] + paths.flatMap { $0 }
let (xs, ys) = (points.map(\.x), points.map(\.y))
let (minY, maxY) = (ys.min()!, ys.max()! + 4)
let height = maxY - minY + 1
let floor = maxY - 2
let (minX, maxX) = (xs.min()! - height, xs.max()! + height)
let width = maxX - minX + 1

func translate(_ index: Index) -> Index {
    (x: index.x - minX, y: index.y - minY)
}

var space = [[Character]](repeating: [Character](repeating: " ", count: width), count: height)
let generator = translate((500, 0))
space[generator.y][generator.x] = "+"
(0...width-1).forEach { space[floor][$0] = "#" }

paths.forEach { path in
    let lines = path.indices.dropFirst().lazy.map { (from: path[$0-1], to: path[$0]) }
    let indices = lines.flatMap { line in
        line.from.x == line.to.x
            ? stride(line.from.y, line.to.y).map { (x: line.from.x, y: $0) }
            : stride(line.from.x, line.to.x).map { (x: $0, y: line.from.y) }
    }.map(translate(_:))
    indices.forEach { space[$0.y][$0.x] = "#" }
}

var stack = [generator]
var units = 0

func search(_ x: Int, _ y: Int) -> Bool {
    guard space[y][x] == " " else { return false }
    stack.append((x: x, y: y))
    return true
}

while let (x, y) = stack.last, y+1 < height {
    if search(x, y+1) || search(x-1, y+1) || search(x+1, y+1) {
        continue
    } else {
        space[y][x] = "o"
        units += 1
        _ = stack.removeLast()
    }
}
print(units)
