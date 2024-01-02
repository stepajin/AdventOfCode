typealias Index = (x: Int, y: Int, z: Int)
typealias Vector = Index
typealias Path = (start: Index, vector: Vector)

func readPath() -> Path? {
    guard let line = readLine() else { return nil }
    let numbers: [Int] = line
        .split { ["@", " ", ","].contains($0) }
        .map(String.init)
        .compactMap(Int.init)
    let start = (x: numbers[0], y: numbers[1], z: numbers[2])
    let vector = (x: numbers[3], y: numbers[4], z: numbers[5])
    return (start: start, vector: vector)
}

func readPaths() -> [Path] {
    var paths: [Path] = []
    while let path = readPath() { paths.append(path) }
    return paths
}

let paths = readPaths()

print()
print("https://quickmath.com/webMathematica3/quickmath/equations/solve/advanced.jsp")
print()
print("Expressions:")
for (index, path) in paths.prefix(3).enumerated() {
    let time = UnicodeScalar(index+65)!
    print("X = \(path.start.x) - \(time) * (\(-1 * path.vector.x) + U)")
    print("Y = \(path.start.y) - \(time) * (\(-1 * path.vector.y) + V)")
    print("Z = \(path.start.z) - \(time) * (\(-1 * path.vector.z) + W)")
}
print()
print("Variables:")
print("XYZUVWABC".map(String.init).joined(separator: "\n"))
print()