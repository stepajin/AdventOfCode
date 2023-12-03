
func parseRange(_ raw: Substring) -> ClosedRange<Int> {
    let bounds = raw.split(separator: "-").map(String.init).compactMap(Int.init)
    return bounds[0]...bounds[1]
}

func readRanges() -> (ClosedRange<Int>, ClosedRange<Int>)? {
    guard let line = readLine() else { return nil }
    let split = line.split(separator: ",")
    return (parseRange(split[0]), parseRange(split[1]))
}

func fullyContains(_ a: ClosedRange<Int>, _ b: ClosedRange<Int>) -> Bool{
    a.lowerBound <= b.lowerBound && a.upperBound >= b.upperBound
}

var count = 0
while let ranges = readRanges() {
    if fullyContains(ranges.0, ranges.1) || fullyContains(ranges.1, ranges.0) {
        count += 1
    }
}

print(count)
