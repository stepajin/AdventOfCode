typealias Network = [String: (left: String, right: String)]

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

let (instructions, network) = readInput()

var node = "AAA"
for step in 1... {
    let index = (step-1) % instructions.count
    let direction = instructions[index]
    let edges = network[node]!
    node = direction ? edges.left : edges.right

    if node == "ZZZ" {
        print(step)
        break
    }
}

