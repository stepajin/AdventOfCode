typealias Race = (time: Int, distance: Int)

func readNumbers() -> [Int] {
    readLine()!.split(separator: " ").map(String.init).compactMap(Int.init)
}

func readRaces() -> [Race] {
    zip(readNumbers(), readNumbers()).map { (time: $0, distance: $1) }
}

func floor(_ double: Double) -> Int {
    Int(double)
}

func ceil(_ double: Double) -> Int {
    double == double.rounded() ? Int(double) : Int(double ) + 1
}

func possibleChargeTimes(_ race: Race) -> ClosedRange<Int> {
    let dSqrt = Double(race.time * race.time - 4 * race.distance).squareRoot()
    let left = (Double(race.time) - dSqrt) / 2
    let right = (Double(race.time) + dSqrt) / 2
    return floor(left) + 1 ... ceil(right) - 1
}

let result = readRaces().map(possibleChargeTimes(_:))
.map(\.count).reduce(1, *)
print(result)
