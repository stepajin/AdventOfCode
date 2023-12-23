
typealias Condition = (Input) -> Bool

enum Destination {
    case workflow(String)
    case reject
    case accept
}

struct Rule {
    let condition: Condition?
    let destination: Destination
}

struct Workflow {
    let name: String
    let rules: [Rule]
}

struct Input {
    let x: Int, m: Int, a: Int, s: Int
}

func partValue(_ parts: Input, _ charater: Character) -> Int {
    switch charater {
        case "x": parts.x
        case "m": parts.m
        case "a": parts.a
        case "s": parts.s
        default: fatalError()
    }
}

func parseCondition(_ string: Substring) -> Condition {
    let part = string.first!
    let op = string.prefix(2).last!
    let number = Int(string.dropFirst(2))!
    return switch op {
        case ">": { partValue($0, part) > number }
        case "<": { partValue($0, part) < number }
        default: fatalError()
    }
}

func parseDestination(_ string: Substring) -> Destination {
    switch string {
        case "R": .reject
        case "A": .accept
        default: .workflow(String(string))
    }
}

func parseRule(_ string: Substring) -> Rule {
    let split = string.split(separator: ":")
    return Rule(
        condition: split.count == 2 ? parseCondition(split[0]) : nil,
        destination: parseDestination(split.last!)
    )
}

func readWorkflow() -> Workflow? {
    guard let line = readLine(), !line.isEmpty else  { return nil }
    let split = line.split(separator: "{")
    return Workflow(
        name: String(split[0]),
        rules: split[1].dropLast().split(separator: ",").map(parseRule(_:))
    )
}

func readWorkflows() -> [Workflow] {
    var workflows: [Workflow] = []
    while let workflow = readWorkflow() {
        workflows.append(workflow)
    }
    return workflows
}

func readInput() -> Input? {
    guard let split = readLine()?.dropFirst().dropLast().split(separator: ",")
    else { return nil }
    let values = split.map { $0.dropFirst(2) }.map(String.init).compactMap(Int.init)
    return Input(x: values[0], m: values[1], a: values[2], s: values[3])
}

func readInputs() -> [Input] {
    var inputs: [Input] = []
    while let input = readInput() {
        inputs.append(input)
    }
    return inputs
}

func evaluate(_ rule: Rule, _ input: Input) -> Bool {
    rule.condition?(input) ?? true
}

func destination(_ workflow: Workflow, _ input: Input) -> Destination {
    workflow.rules.first { evaluate($0, input) }!.destination
}

func evaluate(_ input: Input, _ workflows: [String: Workflow]) -> Bool {
    var dest: Destination = .workflow("in")
    while true {
        switch dest {
            case .accept: return true
            case .reject: return false
            case .workflow(let name):
                let workflow = workflows[name]!
                dest = destination(workflow, input)
        }
    }
}

let workflows = [String: Workflow](
    uniqueKeysWithValues: readWorkflows().map { ($0.name, $0) }
)
let inputs = readInputs()

let result = inputs
    .filter { evaluate($0, workflows) }
    .map { $0.x + $0.m + $0.a + $0.s}
    .reduce(0, +)
print(result)