import Foundation

typealias Network = [String: (left: String, right: String)]
typealias Route = (destination: String, length: Int)

struct State: Hashable {
    let node: String
    let index: Int
}

func state(_ route: Route) -> State {
    State(
        node: route.destination,
        index: index(route.length)
    )
}

func readInstructions() -> [Bool] {
    readLine()!.map { $0 == "L" }
}

func readNetwork() -> Network {
    var network: [String: (left: String, right: String)] = [:]
    while let split = readLine()?.split(separator: " ").map(String.init) {
        network[split[0]] = (
            left: String(split[2].dropFirst().dropLast()),
            right: String(split[3].dropLast())
        )
    }
    return network
}

func readInput() -> ([Bool], Network) {
    let instructions = readInstructions()
    _ = readLine()!
    return (instructions, readNetwork())
}

func pow(_ x: Int, _ y: Int) -> Int64 {
    NSDecimalNumber(
        decimal: pow(NSDecimalNumber(integerLiteral: x).decimalValue, y)
    ).int64Value
}

func primeFactors(_ number: Int) -> [Int] {
    if number <= 3 { return [number] }
    let sqrt = Int(Double(number).squareRoot())
    for x in 2...sqrt {
        guard number % x == 0 else { continue }
        var result = [x]
        result.append(contentsOf: primeFactors(number / x))
        return result
    }
    return [number]
}

func leastCommonMultiple(_ numbers: [Int]) -> Int64 {
    let allFactors = numbers.map(primeFactors(_:))
    let allFactorPows: [[Int: Int]] = allFactors
        .map { [Int: [Int]](grouping: $0, by: { $0 }) }
        .map { $0.mapValues { $0.count } }
    let allFactorBases = allFactorPows.flatMap(\.keys)
    return Set(allFactorBases).map { factorBase in
        pow(
            factorBase,
            allFactorPows.compactMap { $0[factorBase] }.max()!
        )
    }.reduce(1, *)
}

let (instructions, network) = readInput()
var routesToZ: [State: Route] = [:]

func index(_ length: Int) -> Int {
    length % instructions.count
}

func nextIndex(_ after: Int) -> Int {
    index(after + 1)
}

func routeToZ(_ state: State) -> Route {
    if let route = routesToZ[state] {
        return route
    }
    let direction = instructions[state.index]
    let edges = network[state.node]!
    let nextNode = direction ? edges.left : edges.right
    let nextIndex = nextIndex(state.index)
    let subroute = nextNode.last == "Z"
        ? Route(destination: nextNode, length: 0)
        : routeToZ(State(node: nextNode, index: nextIndex))
    let route = Route(
        destination: subroute.destination,
        length: subroute.length + 1
    )
    routesToZ[state] = route
    return route
}

func routeToZ(_ route: Route) -> Route {
    let state = state(route)
    let nextZ = routeToZ(state)
    return Route(
        destination: nextZ.destination,
        length: route.length + nextZ.length
    )
}

func cycleLength(_ _route: Route) -> Int {
    var route = _route
    while true {
        let nextZ = routeToZ(route)
        if state(route) == state(nextZ) { break }
        route = nextZ
    }
    return route.length
}

var cycles: [Int] = network
    .keys
    .filter { $0.last == "A" }
    .map { Route(destination: $0, length: 0) }
    .map(cycleLength(_:))
let result = leastCommonMultiple(cycles)
print(result)
