var heightmap: [[Int]] = []
while let line = readLine()?.map(String.init).compactMap(Int.init) {
    heightmap.append(line)
}

let lowPoints: [Int] = (0..<heightmap.count).flatMap { row in
    (0..<heightmap[row].count).compactMap { column in
        let height = heightmap[row][column]
        let indexes: [(Int, Int)] = [(row, column-1), (row-1, column), (row, column+1), (row+1, column)].filter { 0..<heightmap.count ~= $0 && 0..<heightmap[row].count ~= $1 } 
        let adjacent = indexes.map { heightmap[$0][$1] }
        return adjacent.allSatisfy { $0 > height } ? height : nil
    }
}

let risk = lowPoints.map { $0 + 1 }.reduce(0, +)
print(risk)
