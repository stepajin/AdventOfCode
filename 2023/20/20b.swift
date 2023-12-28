import Foundation

enum ModuleType: Equatable, Hashable {
    case flipFlop(Bool)
    case conjunction([String: Bool])
}

struct Module: Equatable, Hashable {
    let destinations: [String]
    let type: ModuleType
}

func readModules() -> (modules: [String: Module], broadcast: [String]) {
    var modules: [String: Module] = [:]
    var broadcast: [String] = []
    while let split = readLine()?.split(separator: " -> ") {
        let identifier = split[0]
        let destinations = split[1].split(separator: ", ").map(String.init) 
        if identifier == "broadcaster" {
            broadcast = destinations
        } else {
            let name = String(identifier.dropFirst())
            let type: ModuleType = switch identifier.first! {
                case "%": .flipFlop(false)
                case "&": .conjunction([:])
                default: fatalError()
            }
            modules[name] = Module(destinations: destinations, type: type)
        }
    }
    for (key, value) in modules where value.type == .conjunction([:]) {
        let keys = modules.filter { $0.value.destinations.contains(key) }.keys
        let inputs = [String: Bool](uniqueKeysWithValues: keys.map { ($0, false ) })
        modules[key] = Module(
            destinations: value.destinations,
            type: .conjunction(inputs)
        )
        
    }
    return (modules: modules, broadcast: broadcast)
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

var (modules, broadcast) = readModules()

struct State {
    let pulse: Bool
    let source: String
    let destination: String
}

func process(_ state: State) -> (ModuleType, Bool?)? {
    guard let module = modules[state.destination] else { return nil }
    switch module.type {
        case .flipFlop where state.pulse: 
            return (module.type, nil)
        case .flipFlop(let flag):
            return (.flipFlop(!flag), !flag)
        case .conjunction(let inputs):
            var _inputs = inputs
            _inputs[state.source] = state.pulse
            return (
                .conjunction(_inputs),
                _inputs.values.contains(false)
            )
        
    }
}

let destinationNode = modules.first { $0.value.destinations == ["rx"] }!.key
let gateNodes = modules
    .filter { $0.value.destinations.contains(destinationNode) }
    .map { $0.key }
var gateCycles: [String: Int] = [:]

for press in 1... {
    var queue: [State] = broadcast.map {
        State(pulse: false, source: "broadcaster", destination: $0)
    }
    
    while !queue.isEmpty {
        let state = queue.removeFirst()
        
        if state.destination == destinationNode,
            state.pulse,
            gateCycles[state.source] == nil
        {
            gateCycles[state.source] = press
        }
        
        guard let (type, pulse) = process(state),
              let pulse,
              let module = modules[state.destination] else { continue }
        modules[state.destination] = Module(destinations: module.destinations, type: type)
        let states = module.destinations.map {
            State(
                pulse: pulse,
                source: state.destination,
                destination: $0
            )
        }
        queue.append(contentsOf: states)
    }
    
    if gateCycles.count == gateNodes.count {
        break
    }
}

let result = leastCommonMultiple(Array(gateCycles.values))
print(result)

