typealias Instruction = (n: Int, from: Int, to: Int)

func parseCrates(_ line: String) -> [Character] {
    let chars = Array(line)
    return stride(from: 1, to: chars.count, by: 4).map { chars[$0] }
}

func parseStacks(_ crates: [[Character]]) -> [[Character]] {
    (0..<crates[0].count).map { idx in 
        crates.map { $0[idx] }.filter { $0 != " " }.reversed() 
    }
}

func readStacks() -> [[Character]] {
    var crates: [[Character]] = []
    while let line = readLine(), !line.hasPrefix(" 1") {
        crates.append(parseCrates(line))
    }
    _ = readLine()
    return parseStacks(crates)
}

func readInstruction() -> Instruction? {
    guard let line = readLine() else { return nil }
    let split = line.split(separator: " ")
    let numbers = [1, 3, 5].lazy.map { split[$0] }.map(String.init).compactMap(Int.init)
    return (n: numbers[0], from: numbers[1], to: numbers[2])
}

var stacks = readStacks()

while let instruction = readInstruction() {
    let suffix = stacks[instruction.from-1].suffix(instruction.n)
    stacks[instruction.from-1].removeLast(instruction.n)
    stacks[instruction.to-1].append(contentsOf: suffix.reversed())
}

let message = String(stacks.compactMap(\.last))
print(message)
