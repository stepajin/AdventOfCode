
enum Destination {
    case workflow(String)
    case accept
    case reject
}

struct Input {
    var x: ClosedRange<Int>?
    var m: ClosedRange<Int>?
    var a: ClosedRange<Int>?
    var s: ClosedRange<Int>?
}

struct Condition {
    let satisfy: ClosedRange<Int>
    let fail: ClosedRange<Int>
    let keyPath: WritableKeyPath<Input, ClosedRange<Int>?>
}

struct Rule {
    let condition: Condition?
    let destination: Destination
}

struct Workflow {
    let name: String
    let rules: [Rule]
}

func partKeyPath(_ character: Character) -> WritableKeyPath<Input, ClosedRange<Int>?> {
    switch character {
        case "x": \.x
        case "m": \.m
        case "a": \.a
        case "s": \.s
        default: fatalError()
    }
}

func parseCondition(_ string: Substring) -> Condition {
    let keyPath = partKeyPath(string.first!)
    let number = Int(string.dropFirst(2))!
    return switch string.prefix(2).last! {
        case ">":
            Condition(
                satisfy: number+1...Int.max,
                fail: Int.min...number,
                keyPath: keyPath
            )
        case "<":
            Condition(
                satisfy: Int.min...number-1,
                fail: number...Int.max,
                keyPath: keyPath
            )
        default:
            fatalError()
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

func isEmpty(_ input: Input) -> Bool {
    input.x == nil && input.m == nil && input.a == nil && input.s == nil
}

func modified(
    _ input: Input,
    _ keyPath: WritableKeyPath<Input, ClosedRange<Int>?>,
    _ value: ClosedRange<Int>?
) -> Input {
    var _input = input
    _input[keyPath: keyPath] = value
    return _input
}

func apply(_ condition: Condition, _ input: Input) -> (satisfy: Input?, fail: Input?) {
    guard let range = input[keyPath: condition.keyPath] else {
        return (satisfy: nil, fail: input)
    }
    let satisfy = modified(input, condition.keyPath, intersection(range, condition.satisfy))
    let fail = modified(input, condition.keyPath, intersection(range, condition.fail))
    return (
        satisfy: isEmpty(satisfy) ? nil : satisfy,
        fail: isEmpty(fail) ? nil : fail
    )
}

func intersection(_ range: ClosedRange<Int>, _ range2: ClosedRange<Int>) -> ClosedRange<Int>? {
    let clamped = range.clamped(to: range2)
    return range.contains(clamped.lowerBound) ? clamped : nil
}

let workflows = [String: Workflow](
    uniqueKeysWithValues: readWorkflows().map { ($0.name, $0) }
)

struct State {
    let workflow: String
    let rule: Int
    let input: Input
}

let initialInput = Input(
    x: 1...4000,
    m: 1...4000,
    a: 1...4000,
    s: 1...4000
)
var queue: [State] = [State(workflow: "in", rule: 0, input: initialInput)]
var accepted: [Input] = []

func move(_ input: Input, _ workflow: String, rule: Int) {
    let newState = State(
        workflow: workflow,
        rule: rule,
        input: input
    )
    queue.append(newState)
}

func move(_ input: Input, _ destination: Destination) {
    switch destination {
        case .reject:
            break
        case .accept:
            accepted.append(input)
        case .workflow(let workflow):
            move(input, workflow, rule: 0)
    }
}

while !queue.isEmpty {
    let state = queue.removeFirst()

    let rule = workflows[state.workflow]!.rules[state.rule]
    if let condition = rule.condition {
        let (satisfy, fail) = apply(condition, state.input)
        if let satisfy {
            move(satisfy, rule.destination)
        }
        if let fail {
            move(fail, state.workflow, rule: state.rule+1)
        }
    } else {
        move(state.input, rule.destination)
    }
}

let result = accepted
    .map { $0.x!.count * $0.m!.count * $0.a!.count * $0.s!.count }
    .reduce(0, +)

print(result)
