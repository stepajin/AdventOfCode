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
let maxY = isSample ? 20 : 4000000

for y in 0...maxY {
    let ranges: [ClosedRange<Int>] = pairs.compactMap { sensor, beacon in
        let beaconDistance = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
        let yDistance = abs(sensor.y - y)
        let maxXdistance = beaconDistance - yDistance
        guard maxXdistance > 0 else { return nil }
        let lowerBound = max(sensor.x-maxXdistance, 0)
        let upperBound = min(sensor.x+maxXdistance, maxY)
        guard lowerBound <= upperBound else { return nil }
        return lowerBound...upperBound
    }
    let linkedRanges = linkRanges(ranges)
    
    if linkedRanges.count > 1 {
        let x = linkedRanges[0].upperBound + 1
        let tuningFrequency = 4000000 * x + y
        print(tuningFrequency)
        break
    }
}
