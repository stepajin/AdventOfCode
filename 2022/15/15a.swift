struct Index: Hashable, Equatable {
    let x: Int, y: Int
}

func read() -> (sensor: Index, beacon: Index)? {
    guard let split = readLine()?.split(separator: " ") else { return nil }
    let raw = split
        .filter { $0.contains("=") }
        .compactMap {
            $0.split(separator: "=").last?.replacing(",", with: "").replacing(":", with: "") 
        }
    let numbers = raw.map(String.init).compactMap(Int.init)
    return (
        sensor: Index(x: numbers[0], y: numbers[1]),
        beacon: Index(x: numbers[2], y: numbers[3])
    )
}

func linkRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    let sortedRanges = ranges.sorted {
        $0.lowerBound == $1.lowerBound
        ? $0.upperBound <= $1.upperBound
        : $0.lowerBound < $1.lowerBound
    }
    var linkedRanges: [ClosedRange<Int>] = []
    for range in sortedRanges {
        guard let previous = linkedRanges.last,
            range.lowerBound <= previous.upperBound + 1 else {
            linkedRanges.append(range)
            continue
        }
        let linkedRange = previous.lowerBound...max(previous.upperBound, range.upperBound)
        _ = linkedRanges.removeLast()
        linkedRanges.append(linkedRange)
    }
    return linkedRanges
}

var pairs: [(sensor: Index, beacon: Index)] = []
while let pair = read() {
    pairs.append(pair)
}

let isSample = pairs[0].sensor == Index(x: 2, y: 18)
let y = isSample ? 10 : 2000000

var ranges: [ClosedRange<Int>] = pairs.compactMap { sensor, beacon in
    let beaconDistance = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
    let yDistance = abs(sensor.y - y)
    let maxXdistance = beaconDistance - yDistance
    guard maxXdistance > 0 else { return nil }
    return sensor.x-maxXdistance...sensor.x+maxXdistance
}
let linkedRanges = linkRanges(ranges)
let count = linkedRanges.map { $0.count }.reduce(0, +)
let beaconCount = Set(pairs.map(\.beacon).filter { $0.y == y }).count

print(count - beaconCount)
