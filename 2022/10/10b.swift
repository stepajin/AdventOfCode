enum Instruction {
    case noop
    case add(x: Int)
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
var cycle = 1
var output = ""

func draw() {
    let pos = (cycle - 1) % 40
    let char = pos-1...pos+1 ~= x ? "#": " "
    output.append(char)
    
    if output.count == 40 {
        print(output)
        output = ""
    }
}

print()
while let instruction = readInstruction() {
    switch instruction {
        case .add(let add):
            draw()
            cycle += 1
            draw()
            x += add
            cycle += 1
        case .noop:
            draw()
            cycle += 1
    }
}
print()
