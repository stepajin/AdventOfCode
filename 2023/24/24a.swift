
typealias Index = (x: Double, y: Double)
typealias Vector = Index
typealias Path = (start: Index, vector: Vector)
typealias LineFunction = (a: Double, b: Double)

func readPath() -> Path? {
    guard let line = readLine() else { return nil }
    let numbers: [Double] = line
        .split { ["@", " ", ","].contains($0) }
        .map(String.init)
        .compactMap(Double.init)
    let start = (x: numbers[0], y: numbers[1])
    let vector = (x: numbers[3], y: numbers[4])
    return (start: start, vector: vector)
}

func readPaths() -> [Path] {
    var paths: [Path] = []
    while let path = readPath() { paths.append(path) }
    return paths
}

func add(_ index: Index, _ vector: Vector) -> Index {
    Index(x: index.x + vector.x, y: index.y + vector.y)
}

func lineFunction(_ point1: Index, _ point2: Index) -> LineFunction {
    let a = (point2.y-point1.y) / (point2.x-point1.x)
    let b = point1.y - a * point1.x
    return (a: a, b: b)
}

func lineFunction(_ path: Path) -> LineFunction {
    lineFunction(
        path.start,
        add(path.start, path.vector)
    )
}

func intersection(_ line1: LineFunction, _ line2: LineFunction) -> Index? {
    guard line1.a - line2.a != 0 else { return nil }
    let x = (line2.b - line1.b) / (line1.a - line2.a)
    let y = line1.a * x + line1.b
    guard x != .infinity && y != .infinity else { return nil }
    return (x: x, y: y)
}

func isInArea(_ point: Index, _ area: ClosedRange<Double>) -> Bool {
    area ~= point.x && area ~= point.y
}

func isInPath(_ point: Index, _ path: Path) -> Bool {
    path.vector.x >= 0
        ? point.x >= path.start.x
        : point.x < path.start.x
}


let paths = readPaths()
let lines = paths.map(lineFunction(_:))
let testArea = paths.count == 300
    ? 200000000000000...400000000000000
    : 7.0...27.0

let result: Int = lines.indices.map { index1 in
    (index1+1..<lines.endIndex).filter { index2 in
        guard let inter = intersection(lines[index1], lines[index2]) else { return false }
        return isInPath(inter, paths[index1])
            && isInPath(inter, paths[index2])
            && isInArea(inter, testArea)
    }.count
}.reduce(0, +)
print(result)