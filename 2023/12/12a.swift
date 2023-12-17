typealias Record = (springs: String, arrangement: [Int])

func readRecord() -> Record? {
    guard let split = readLine()?.split(separator: " ") else { return nil }
    return (
        springs: String(split[0]),
        arrangement: split[1].split(separator: ",").map(String.init).compactMap(Int.init)
    )
}

struct State: Hashable {
    let closed: [Int]
    let open: Int
    let remaining: String.SubSequence
}

func adding(_ state: State, _ add: Character) -> State {
    switch add {
        case "#":
            State(
                closed: state.closed,
                open: state.open + 1,
                remaining: state.remaining.dropFirst()
            )
        case ".":
            State(
                closed: state.closed + (state.open > 0 ? [state.open] : []),
                open: 0,
                remaining: state.remaining.dropFirst()
            )
        default:
            fatalError()
    }
}

func isPossible(_ state: State, _ arrangement: [Int]) -> Bool {
    if state.closed.count > arrangement.count { return false }
    if state.closed.count == arrangement.count { return state.open == 0 }
    let prefix = Array(arrangement.prefix(state.closed.count))
    guard prefix == state.closed else { return false }
    return arrangement[state.closed.count] >= state.open
}

var cache: [State: Int] = [:]
func search(_ state: State, _ arrangement: [Int]) -> Int {
    if let value = cache[state] {
        return value
    }
    
    guard let nextSpring = state.remaining.first else {
        let closed = state.closed + (state.open > 0 ? [state.open] : [])
        let result = closed == arrangement ? 1 : 0
        cache[state] = result
        return result
    }
    guard isPossible(state, arrangement) else {
        cache[state] = 0
        return 0
    }

    switch nextSpring {
        case ".", "#":
            let newState = adding(state, nextSpring)
            let result = search(newState, arrangement)
            cache[state] = result
            return result
        case "?":
            let damagedState = adding(state, "#")
            let operationalState = adding(state, ".")
            let result = search(damagedState, arrangement)
                + search(operationalState, arrangement)
            cache[state] = result
            return result
        default:
            fatalError()
    }
}

func arrangements(_ record: Record) -> Int {
    cache = [:]
    let state = State(
        closed: [],
        open: 0,
        remaining: record.springs.prefix(record.springs.count)
    )
    return search(state, record.arrangement)
}

var result = 0
while let record = readRecord() {
    result += arrangements(record)
}
print(result)

