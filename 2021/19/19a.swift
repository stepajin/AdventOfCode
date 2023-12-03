var uidCounter: Int = 0
func uid() -> String {
    uidCounter += 1
    return "\(uidCounter)"
}

extension Array where Element: Hashable {
    func uniq() -> [Element] { // ordered
        var set = Set<Element>()
        var array = [Element]()
        for e in self {
            guard !set.contains(e) else { continue }
            set.insert(e)
            array.append(e)
        }
        return array
    }
}

struct Point: CustomDebugStringConvertible, Hashable {
    let x: Int, y: Int, z: Int
    
    var debugDescription: String { "[\(x),\(y),\(z)]" }
    var rotatedClockwise: Point { Point(x: z, y: y, z: -x) }
    var rotations: [Point] { rotations { $0.rotatedClockwise } }
    var rolledRight: Point { Point(x: y, y: -x, z: z) }
    var rollsSideways: [Point] { rotations { $0.rolledRight } }
    var rolledBack: Point { Point(x: x, y: z, z: -y) }
    var rollsForwardBackward: [Point] { rotations { $0.rolledBack } }
    var rolls: [Point] { (rollsSideways + rollsForwardBackward).uniq() }
    var symetries: [Point] { rolls.flatMap { $0.rotations }.uniq() }
    var sum: Int { abs(x) + abs(y) + abs(z) }
    
    func rotations(_ rotation: (Point) -> Point) -> [Point] {
        (1...3).reduce([self]) { acc, _ in acc + [rotation(acc.last!)] }
    }
    
    func distance(to point: Point) -> Point {
        Point(x: abs(x-point.x), y: abs(y-point.y), z: abs(z-point.z))
    }
    
    static func map(_ left: Point, _ right: Point, _ f: (Int, Int) -> Int) -> Point {
        Point(x: f(left.x, right.x), y: f(left.y, right.y), z: f(left.z, right.z))
    }
    static func +(left: Point, right: Point) -> Point { map(left, right, +) }
    static func -(left: Point, right: Point) -> Point { map(left, right, -) }
    static func *(left: Point, right: Point) -> Point { map(left, right, *) }
}

struct Map {
    let points: [Point]
    let distances: [Set<Point>]
    init(_ points: [Point]) {
        self.points = points
        distances = points.map { p1 in
            Set(points.map { p2 in p2.distance(to: p1) })
        }
    }
}

struct Space {
    let id = uid()
    let rotations: [Map]
    init(_ points: [Point]) {
        let symetries = points.map { $0.symetries }
        rotations = (0...23).map { idx -> Map in
            Map(symetries.map { $0[idx] })
        }
    }
}

struct Scanner {
    let id = uid()
    let map: Map
    let position: Point
}

struct Projection {
    let point: Point
    let image: Point
}

func find3Projections(from map: Map, to imageMap: Map) -> [Projection]? {
    var projections: [Projection] = []
    for scannerIdx in map.distances.indices {
        let distances = map.distances[scannerIdx]
        for mapIdx in imageMap.distances.indices {
            guard distances.intersection(imageMap.distances[mapIdx]).count >= 12 else {
                continue
            }
            let projection = Projection(point: map.points[scannerIdx], image: imageMap.points[mapIdx])
            projections.append(projection)
            if projections.count == 3 {
                return projections
            }
        }
    }
    return nil
}

func vector(_ projections: [Projection]) -> Point {
    let vectors: [Point] = [
        (1, 1, 1), (1, 1, -1), (1, -1, 1), (1, -1, -1),
        (-1, 1, 1), (-1, 1, -1), (-1, -1, 1), (-1, -1, -1)
    ].map { Point(x: $0, y: $1, z: $2) }
    return vectors.first { vector in
        let values = projections.map { $0.point + vector * $0.image }
        return values[0] == values[1] && values[0] == values[2]
    }!
}

func alignedScanner(_ map: Map, to scanner: Scanner) -> Scanner {
    guard let projections = find3Projections(from: scanner.map, to: map) else { fatalError() }
    let vector = vector(projections)
    let position = projections[0].point + vector * projections[0].image
    let points = map.points.map { position - vector * $0 }
    return Scanner(map: Map(points), position: position)
}

func alignedScanner(_ space: Space, to scanner: Scanner) -> Scanner? {
    if let map = space.rotations.first(where: { map in
        scanner.map.distances.contains { d in
            map.distances.contains { d.intersection($0).count >= 12 }
        }
    }) {
        return alignedScanner(map, to: scanner)
    }
    return nil
}

func readPoints() -> [Point]? {
    _ = readLine()
    var points: [Point] = []
    while let coords: [Int] = readLine()?.split(separator: ",").map(String.init).compactMap(Int.init), coords.count == 3 {
        points.append(Point(x: coords[0], y: coords[1], z: coords[2]))
    }
    return points.count > 0 ? points : nil
}

let rootScanner = Scanner(map: Map(readPoints()!), position: Point(x: 0, y: 0, z: 0))
var spaces: [Space] = []
while let points = readPoints() {
    spaces.append(Space(points))
}

var scanners: [Scanner] = [rootScanner]
var cache: Set<String> = []
outerLoop: while !spaces.isEmpty {
     for index in spaces.indices {
        for scanner in scanners.reversed() {
            let space = spaces[index]
            let cacheId = "\(scanner.id)-x-\(space.id)"
            if cache.contains(cacheId) { continue }
            if let newScanner = alignedScanner(space, to: scanner) {
                scanners.append(newScanner)
                spaces.remove(at: index)
                continue outerLoop
            } else {
                cache.insert(cacheId)
            }
        }
    }
}

let allPoints = Set(scanners.flatMap { $0.map.points })
print(allPoints.count)
