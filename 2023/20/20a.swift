
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

var lows = 0, highs = 0

for _ in 1...1000 {
    var queue: [State] = broadcast.map {
        State(pulse: false, source: "broadcaster", destination: $0)
    }
    lows += 1
    
    while !queue.isEmpty {
        let state = queue.removeFirst()
        if state.pulse { highs += 1 } else { lows += 1 }

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
}

let result = highs * lows
print(result)

