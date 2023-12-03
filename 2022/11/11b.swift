import Foundation

struct Monkey {
    var items: [Int]
    let operation: (Int) -> Int
    let modulo: Int
    let ifTrue: Int
    let ifFalse: Int
}

func parseNumbers(_ raw: String) -> [Int] {
    raw.split(separator: " ")
        .map { $0.components(separatedBy: CharacterSet.alphanumerics.inverted).joined() }
        .compactMap(Int.init)
}

func parseOperation(_ raw: String) -> (Int) -> Int {
    let split = raw.split(separator: "=")[1].dropFirst().split(separator: " ").map(String.init)
    let op: (Int, Int) -> Int = split[1] == "*" ? { $0 * $1 } : { $0 + $1 }
    let const1 = Int(split[0])
    let const2 = Int(split[2])
    return { old in op(const1 ?? old, const2 ?? old) }
}

func readMonkey() -> Monkey? {
    let lines = (1...6).compactMap({ _ in readLine() })
    guard lines.count == 6 else { return nil }
    _ = readLine()
    
    return Monkey(
        items: parseNumbers(lines[1]),
        operation: parseOperation(lines[2]),
        modulo: parseNumbers(lines[3])[0],
        ifTrue: parseNumbers(lines[4])[0],
        ifFalse: parseNumbers(lines[5])[0]
    )
}

var monkeys: [Monkey] = []
while let monkey = readMonkey() {
    monkeys.append(monkey)
}

let modulo = monkeys.map(\.modulo).reduce(1, *)
var inspections = [Int](repeating: 0, count: monkeys.count)

for _ in 1...10000 {
    for index in monkeys.indices {
        let monkey = monkeys[index]
        for item in monkey.items {
            let newItem = monkey.operation(item) % modulo
            let target = newItem % monkey.modulo == 0 ? monkey.ifTrue : monkey.ifFalse
            monkeys[target].items.append(newItem)
        }
        inspections[index] += monkey.items.count
        monkeys[index].items = []
    }
}

let result = inspections.sorted().reversed().prefix(2).reduce(1, *)
print(result)
