let maxTime = 26

struct Valve {
    let name: String
    let rate: Int
    let pipes: [String]
}

struct State: Equatable, Hashable {
    let position: Int
    let time: Int
    let rate: Int
    let score: Int
    let destinations: Array<Int>
    let potentialRate: Int
    
    var remainingTime: Int { maxTime - time }
    var potential: Int { score + remainingTime * (rate + potentialRate) }
}

func readValve() -> Valve? {
    guard let split = readLine()?.split(separator: " ") else { return nil }
    let name = String(split[1])
    let rate = Int(String(split[4].split(separator: "=")[1].dropLast())) ?? 0
    let pipes = split[9..<split.count].map {
        $0.hasSuffix(",") ? $0.dropLast() : $0
    }.map(String.init)
    return Valve(name: name, rate: rate, pipes: pipes)
}

func readValves() -> [Valve] {
    var valves: [Valve] = []
    while let valve = readValve() {
        valves.append(valve)
    }
    return valves
}

func floydWarshall(count: Int, edges: [(Int, Int)]) -> [[Int]] {
    var graph = [[Int]](repeating: [Int](repeating: 1000000, count: count), count: count)
    for (from, to) in edges {
        graph[from][to] = 1
    }
    for id in 0..<count {
        graph[id][id] = 0
    }
    for k in 0..<count {
        for i in 0..<count {
            for j in 0..<count {
                if graph[i][j] > graph[i][k] + graph[k][j] {
                    graph[i][j] = graph[i][k] + graph[k][j]
                }
            }
        }
    }
    return graph
}

let valves = readValves()
let count = valves.count
let names = valves.map(\.name).sorted()
let ids = [String: Int](uniqueKeysWithValues: zip(names, (0..<count)))
let valvesMap = [Int: Valve](uniqueKeysWithValues: valves.map { (ids[$0.name]!, $0) })

let edges: [(Int, Int)] = valves.flatMap { valve -> [(Int, Int)] in
    guard let id = ids[valve.name] else { return [] }
    return valve.pipes.compactMap { ids[$0] }.map { (id, $0) }
}

var graph = floydWarshall(count: count, edges: edges)

for to in 0..<count where valvesMap[to]?.rate == 0 {
    for from in 0..<count {
        graph[from][to] = -1
    }
}

func search(destinations: Array<Int>, minimum: Int) -> Int {
    let initialState = State(
        position: 0,
        time: 0,
        rate: 0,
        score: 0,
        destinations: destinations,
        potentialRate: destinations.map { valvesMap[$0]!.rate }.reduce(0, +)
    )
        
    var stack: [State] = [initialState]
    var maximum = minimum
    
    while !stack.isEmpty {
        let state = stack.removeLast()
        
        if state.time == maxTime {
            if state.score > maximum {
                maximum = state.score
            }
            continue
        }
        guard state.potential > maximum else { continue }
        
        var moved = false
        for index in state.destinations.indices {
            let to = state.destinations[index]
            let duration = graph[state.position][to]
            guard state.time + duration <= maxTime else { continue }
            let destination = valvesMap[to]!
            var destinations = state.destinations
            destinations.remove(at: index)
            let move = State(
                position: to,
                time: state.time + 1 + duration,
                rate: state.rate + destination.rate,
                score: state.score + state.rate + duration * state.rate,
                destinations: destinations,
                potentialRate: state.potentialRate - destination.rate
            )
            guard move.potential > maximum else { continue }
            stack.append(move)
            moved = true
        }
        
        if !moved {
            let remainingTime = maxTime - state.time
            let stay = State(
                position: state.position,
                time: maxTime,
                rate: state.rate,
                score: state.score + remainingTime * state.rate,
                destinations: state.destinations,
                potentialRate: state.potentialRate
            )
            if stay.score > maximum {
                maximum = stay.score
            }
        }
    }
    return maximum
}

func combinations(_ values: [Int]) -> [[Int]] {
    guard !values.isEmpty else { return [[]] }
    return combinations(Array(values[1...])).flatMap { [$0, [values[0]] + $0] }
}

let openableValves = Set(valves.filter { $0.rate > 0 }.map(\.name).compactMap { ids[$0] })
let allCombinations = combinations(Array(openableValves))
    .filter { $0.count >= openableValves.count - $0.count }

var bestScore = 0
for combination in allCombinations {
    let remaining = openableValves.subtracting(Set(combination))
    let score1 = search(destinations: combination, minimum: 0)
    let score2 = search(destinations: Array(remaining), minimum: bestScore - score1)
    if score1 + score2 > bestScore {
        bestScore = score1 + score2
    }
}

print(bestScore)
