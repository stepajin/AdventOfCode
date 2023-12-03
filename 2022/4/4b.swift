
func parseRange(_ raw: Substring) -> ClosedRange<Int> {
    let bounds = raw.split(separator: "-").map(String.init).compactMap(Int.init)
    return bounds[0]...bounds[1]
}

func readRanges() -> (ClosedRange<Int>, ClosedRange<Int>)? {
    guard let line = readLine() else { return nil }
    let split = line.split(separator: ",")
    return (parseRange(split[0]), parseRange(split[1]))
}

var count = 0
while let ranges = readRanges() {
    if ranges.0.overlaps(ranges.1) {
        count += 1
    }
}

print(count)
