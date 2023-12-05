typealias NodeRange = ClosedRange<Int>
typealias Rule = (source: NodeRange, dest: NodeRange)
typealias Map = [Rule]

func readSources() -> [Int] {
    readLine()!.split(separator: " ").dropFirst()
        .map(String.init).compactMap(Int.init)
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

func readInput() -> ([Int], [Map]) {
    let sources = readSources()
    _ = readLine()
    var maps: [Map] = []
    while let map = readMap() {
        maps.append(map)
    }
    return (sources, maps)
}

func destination(_ rule: Rule, _ source: Int) -> Int {
    rule.dest.lowerBound + source - rule.source.lowerBound
}

func destination(_ map: Map, _ source: Int) -> Int? {
    map.first { $0.source ~= source }.map { destination($0, source) }
}

func destination(_ source: Int, _ map: Map) -> Int {
    destination(map, source) ?? source
}

func destinations(_ sources: [Int], _ map: Map) -> [Int] {
    sources.map { destination($0, map) }
}

func destinations(_ sources: [Int], _ maps: [Map]) -> [Int] {
    maps.reduce(sources, destinations(_:_:))
}

let (sources, maps) = readInput()
let result = destinations(sources, maps).min()!
print(result)
