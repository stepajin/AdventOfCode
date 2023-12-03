enum Instruction {
    case noop
    case add(x: Int)
    
    var cycles: Int {
        switch self {
            case .noop: return 1
            case .add: return 2
        }
    }
}

func readInstruction() -> Instruction? {
    guard let split = readLine()?.split(separator: " ") else { return nil }
    switch split[0] {
        case "noop": return .noop
        case "addx": return .add(x: Int(String(split[1]))!)
        default: return nil
    }
}

var x = 1
var cycle = 0
var sum = 0

while let instruction = readInstruction() {
    if ((cycle + 20) / 40) < ((cycle + instruction.cycles + 20) / 40) {
        let thresholdCycle = ((cycle + 20) / 40) * 40 + 20
        sum += x * thresholdCycle
        print(x * thresholdCycle, x * cycle)
    }
    if case .add(let add) = instruction {
        x += add	
    }
    cycle += instruction.cycles
}

print(sum)