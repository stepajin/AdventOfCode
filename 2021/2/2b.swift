enum Instruction {
    case forward(Int)
    case up(Int)
    case down(Int)
}

func readInstruction() -> Instruction? {
    guard let line = readLine() else { return nil }
    let parts = line.split(separator: " ")
    guard let instruction = parts.first, 
          let rawValue = parts.last,
          let value = Int(rawValue) else { return nil }
    switch instruction {
    case "forward": return .forward(value)
    case "up": return .up(value)
    case "down": return .down(value)
    default: return nil
    }
}

var depth = 0
var position = 0
var aim = 0
while let instruction = readInstruction() {
    switch instruction {
    case let .forward(value):
        position += value
        depth += aim * value
    case let .up(value): 
        aim -= value
    case let .down(value): 
        aim += value
    }
}

print(depth * position)
