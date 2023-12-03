
enum Line {
    case cd(String)
    case ls
    case dir(String)
    case file(Int)
}

func read() -> Line? {
    guard let split = readLine()?.split(separator: " ").map(String.init) else { return nil }
    switch split[0] {
        case "$" where split[1] == "cd":
            return .cd(split[2])
        case "$" where split[1] == "ls":
            return .ls
        case "dir": 
            return .dir(split[1])
        default:
            guard let size = Int(split[0]) else { return nil }
            return .file(size)
    }
}

var stack: [Int] = [0]
var total = 0

func execute(_ line: Line) {
    switch line {
        case .cd("/"):
            while stack.count > 1 {
                execute(.cd(".."))
            }
        case .cd(".."):
            let current = stack.removeLast()
            if current <= 100000 {
                total += current
            }
            stack.append(stack.removeLast() + current)
        case .cd(_):
            stack.append(0)
        case .file(let size):
            var current = stack.removeLast()
            current += size
            stack.append(current)
        case .ls,
            .dir(_):
            break
    }
}

while let line = read() {
    execute(line)
}
execute(.cd("/"))

print(total)