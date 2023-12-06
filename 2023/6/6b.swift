typealias Race = (time: Int, distance: Int)

func readNumber() -> Int {
    Int(readLine()!.split(separator: " ").dropFirst().map(String.init).joined())!
}

func readRace() -> Race {
    (time: readNumber(), distance: readNumber())
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

let result = possibleChargeTimes(readRace()).count
print(result)
