
typealias Operation = (sign: String, left: Operand, right: Operand)

indirect enum Operand {
    case value(Int)
    case variable
    case operation(Operation)
    
    var prefix: String {
        switch self {
            case .variable:
                return "x"
            case .value(let value):
                return String(value)
            case .operation(let op):
                return "\(op.sign)(\(op.left.prefix), \(op.right.prefix))"
        }
    }
    
    var infix: String {
        switch self {
            case .variable:
                return "x"
            case .value(let value):
                return String(value)
            case .operation(let op):
                return "(\(op.left.infix) \(op.sign) \(op.right.infix))"
        }
    }
}

enum Job {
    case value(Int)
    case operation(sign: String, left: String, right: String)
}

func mathOperation(_ sign: String) -> (Int, Int) -> Int {
    switch sign {
        case "+": return { $0 + $1 }
        case "*": return { $0 * $1 }
        case "/": return { $0 / $1 }
        default: return { $0 - $1 }
    }
}

func invert(_ sign: String) -> String {
    switch sign {
        case "+": return "-"
        case "-": return "+"
        case "/": return "*"
        case "*": return "/"
        default: return ""
    }
}

func readMonkey() -> (id: String, job: Job)? {
    guard let split = readLine()?.split(separator: " ").map(String.init) else { return nil }
    let id = String(split[0].dropLast())
    if let value = Int(String(split[1])) {
        return (id: id, job: .value(value))
    } else {
        return (id: id, job: .operation(sign: split[2], left: split[1], right: split[3]))
    }
}

var jobs: [String: Job] = [:]
while let (id, job) = readMonkey() {
    jobs[id] = job
}

var operands: [String: Operand] = [:]
operands["humn"] = .variable

func expand(_ id: String) -> Operand {
    if let cached = operands[id] {
        return cached
    }
    guard let job = jobs[id] else {
        return .value(0)
    }
    
    func caching(_ operand: Operand) -> Operand {
        operands[id] = operand
        return operand
    }
    
    switch job {
        case .value(let value):
            return caching(.value(value))
        case .operation(let sign, let id1, let id2):
            let left = expand(id1)
            let right = expand(id2)
            if case .value(let value1) = left,
                case .value(let value2) = right {
                let value = mathOperation(sign)(value1, value2)
                return caching(.value(value))
            } else {
                let operation = (sign: sign, left: left, right: right)
                return caching(.operation(operation))
            }
    }
}

func solveEquation(_ operation: Operation, equalTo equalityValue: Int) -> Int {
    let invertedSign = invert(operation.sign)
    
    switch operation {
        case ("-", .value(let leftValue), .operation),
            ("/", .value(let leftValue), .operation),
            ("-", .value(let leftValue), .variable),
            ("/", .value(let leftValue), .variable):
            let invertedOperation: Operation = (sign: invertedSign, left: .value(equalityValue), right: operation.right)
            return solveEquation(invertedOperation, equalTo: leftValue)
            
        case (_, .operation(let op), .value(let value)),
            (_, .value(let value), .operation(let op)):
            let newValue = mathOperation(invertedSign)(equalityValue, value)
            return solveEquation(op, equalTo: newValue)

        case (_, .variable, .value(let rightValue)):
            let newValue = mathOperation(invertedSign)(equalityValue, rightValue)
            return newValue
            
        // Not supported
        default:
            return 0
    }
}

if case let .operation(_, id1, id2) = jobs["root"] {
    let left = expand(id1)
    let right = expand(id2)
    let result: Int
    
    switch (left, right) {
        case (.value(let value), .operation(let operation)),
            (.operation(let operation), .value(let value)):
            result = solveEquation(operation, equalTo: value)
        default:
            result = 0
    }
    
    print(result)
}
