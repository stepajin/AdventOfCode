
typealias Operation = (Int, Int) -> Int

enum Job {
    case value(Int)
    case operation(String, String, Operation)
}

func operation(_ raw: String) -> Operation {
    switch raw {
        case "+": return { $0 + $1 }
        case "*": return { $0 * $1 }
        case "/": return { $0 / $1 }
        default: return { $0 - $1 }
    }
}

func readMonkey() -> (id: String, job: Job)? {
    guard let split = readLine()?.split(separator: " ").map(String.init) else { return nil }
    let id = String(split[0].dropLast())
    if let value = Int(String(split[1])) {
        return (id: id, job: .value(value))
    } else {
        return (id: id, job: .operation(split[1], split[3], operation(split[2])))
    }
}

var jobs: [String: Job] = [:]
while let (id, job) = readMonkey() {
    jobs[id] = job
}

var cache: [String: Int] = [:]
func evaluate(_ id: String) -> Int {
    if let value = cache[id] {
        return value
    }
    guard let job = jobs[id] else {
        return 0
    }
    switch job {
        case .value(let value):
            cache[id] = value
            return value
        case .operation(let id1, let id2, let operation):
            let value = operation(evaluate(id1), evaluate(id2))
            cache[id] = value
            return value
    }
}

let result = evaluate("root")
print(result)
