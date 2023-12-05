typealias NodeRange = ClosedRange<Int>
typealias Rule = (source: NodeRange, dest: NodeRange)
typealias Map = [Rule]

func readSources() -> [NodeRange] {
    let numbers = readLine()!.split(separator: " ").dropFirst()
        .map(String.init).compactMap(Int.init)
    return stride(from: 0, to: numbers.count, by: 2).map {
        let (start, length) = (numbers[$0], numbers[$0+1])
        return start...start+length-1
    }
}

func readRule() -> Rule? {
    guard let line = readLine(), !line.isEmpty else { return nil }
    let numbers = line.split(separator: " ")
        .map(String.init).compactMap(Int.init)
    let (dest, source, length) = (numbers[0], numbers[1], numbers[2])
    return (source: source...source+length-1, dest: dest...dest+length-1)
}

func readMap() -> Map? {
    _ = readLine()
    var rules: [Rule] = []
    while let rule = readRule()  {
        rules.append(rule)
    }
    return rules.isEmpty ? nil : rules
}

func readInput() -> ([NodeRange], [Map]) {
    let sources = readSources()
    _ = readLine()
    var maps: [Map] = []
    while let map = readMap() {
        maps.append(map)
    }
    return (sources, maps)
}

func concatenate(_ ranges: [NodeRange]) -> [NodeRange] {
    ranges.sorted { $0.lowerBound <= $1.lowerBound }
          .reduce([])
    { acc, range in
        guard let lastRange = acc.last else { return [range] }
        return lastRange.upperBound + 1 == range.lowerBound
            ? acc.dropLast() + [lastRange.lowerBound...range.upperBound]
            : acc + [range]
    }
}

func destination(_ rule: Rule, _ source: Int) -> Int {
    rule.dest.lowerBound + source - rule.source.lowerBound
}

func destinations(_ rule: Rule, _ source: NodeRange) -> NodeRange {
    destination(rule, source.lowerBound)...destination(rule, source.upperBound)
}

func destinations(_ source: NodeRange, _ map: Map) -> [NodeRange] {
    var lowerBound = source.lowerBound
    var ranges: [NodeRange] = []
    for rule in map where rule.source.overlaps(source) {
        if lowerBound < rule.source.lowerBound {
            ranges.append(lowerBound...rule.source.lowerBound-1)
        }
        let intersection = source.clamped(to: rule.source)
        ranges.append(destinations(rule, intersection))
        lowerBound = intersection.upperBound + 1
    }
    return lowerBound < source.upperBound 
        ? ranges + [lowerBound...source.upperBound]
        : ranges
}

func destinations(_ sources: [NodeRange], _ map: Map) -> [NodeRange] {
    concatenate(
        sources.flatMap { destinations($0, map) }
    )
}

func destinations(_ sources: [NodeRange], _ maps: [Map]) -> [NodeRange] {
    maps.reduce(sources, destinations(_:_:))
}

let (sources, maps) = readInput()
let orderedMaps = maps.map {
    $0.sorted { $0.source.lowerBound <= $1.source.lowerBound }
}
let result = destinations(sources, orderedMaps)[0].lowerBound
print(result)
