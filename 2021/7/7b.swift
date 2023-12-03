func floor(_ d: Double) -> Int { Int(d) }
func ceil(_ d: Double) -> Int { Double(Int(d)) == d ? Int(d) : Int(d) + 1 }

guard let positions: [Int] = readLine()?.split(separator: ",").map(String.init).compactMap(Int.init) else { fatalError() }

let sortedPositions = positions.sorted()
let maxDistance = sortedPositions.last! - sortedPositions.first!
let costs: [Int] = (0...maxDistance).map { ($0 * ($0+1)) / 2 }
let average = Double(positions.reduce(0, +)) / Double(positions.count)

func cost(_ position: Int) -> Int {
    positions.map { costs[abs($0-position)] }.reduce(0, +) 
}

let solution = min(cost(floor(average)), cost(ceil(average)))
print(solution)
