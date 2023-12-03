typealias Idx = [Int]
extension Idx {
    var row: Int { self[0] }
    var column: Int { self[1] }
    var adjacentIndexes: [Idx] {
        [[row, column-1], [row-1, column], [row, column+1], [row+1, column]]
    }
}
extension Array where Element: MutableCollection, Element.Index == Int {
    subscript(_ idx: Idx) -> Element.Iterator.Element {
        get { self[idx.row][idx.column] }
        set { self[idx.row][idx.column] = newValue }
    }
    func contains(_ idx: Idx) -> Bool {
        (0..<count ~= idx.row) && (0..<self[idx.row].count ~= idx.column)
    }
    func adjacentIndexes(_ idx: Idx) -> [Idx] {
        idx.adjacentIndexes.filter(contains(_:))
    }
}

var heightmap: [[Int]] = []
while let line = readLine()?.map(String.init).compactMap(Int.init) {
    heightmap.append(line)
}

var basins: [[Set<Idx>]] = (0..<heightmap.count).map { r -> [Set<Idx>] in
    (0..<heightmap[r].count).map { c in heightmap[r][c] < 9 ? Set([[r, c]]) : [] }
}

for n in (0...7).reversed() {
    for row in (0..<heightmap.count) {
        for column in (0..<heightmap[row].count) {
            let index: Idx = [row, column]
            guard heightmap[index] == n else { continue }
            let flows: [Idx] = heightmap.adjacentIndexes(index).filter { heightmap[$0] > n }
            basins[index] = flows.reduce(basins[index]) { $0.union(basins[$1]) }
        }
    }
}

let counts: [Int] = basins.flatMap { $0.map { $0.count } }.sorted().reversed()
print(counts[0...2].reduce(1, *))
