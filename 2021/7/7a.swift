guard let positions: [Int] = readLine()?.split(separator: ",").map(String.init).compactMap(Int.init) else { fatalError() }

let median: Int = positions.sorted()[positions.count / 2]
let sum = positions.map { abs($0 - median) }.reduce(0, +)
print(sum)
