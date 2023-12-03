func adjacentIndexes(_ index: (Int, Int)) -> [(Int, Int)] {
    (-1...1).flatMap { r in (-1...1).map { c in (index.0+r, index.1+c) } }
    .filter { $0 != index && (0...9) ~= $0.0 && (0...9) ~= $0.1 }
}

var octopuses: [[Int]] = (1...10).map { _ in readLine()!.map(String.init).compactMap(Int.init) }
let allIndexes: [(Int, Int)] = (0...9).flatMap { r in (0...9).map { c in (r, c) } }

let step = (1...Int.max).first { step in
    allIndexes.forEach { octopuses[$0][$1] = octopuses[$0][$1] + 1 }
    var flashed = 0
    var queue = allIndexes.filter { octopuses[$0][$1] > 9 }
    while queue.count > 0 {
        let index = queue.removeFirst()
        if octopuses[index.0][index.1] == 0 { continue }
        octopuses[index.0][index.1] = 0
        let adjacent = adjacentIndexes(index).filter { octopuses[$0][$1] > 0 }
        adjacent.forEach { octopuses[$0][$1] = octopuses[$0][$1] + 1 }
        queue += adjacent.filter { octopuses[$0][$1] > 9 }
        flashed += 1
    }
    return flashed == 100
}!
print(step)