enum Element: CustomDebugStringConvertible, Equatable, Comparable {
    case list([Element])
    case value(Int)
    
    var debugDescription: String {
        switch self {
            case .list(let elements):
                return "[" + elements.map { $0.debugDescription }.joined(separator: ",") + "]"
            case .value(let value):
                return String(value)
        }
    }
    
    var elements: [Element] {
        switch self {
            case .list(let elements): return elements
            case .value: return [self]
        }
    }
    
    static func >(_ left: Element, _ right: Element) -> Bool {
        compare(left, right) == 0
    }
    
    static func ==(_ left: Element, _ right: Element) -> Bool {
        compare(left, right) == 1
    }
    
    static func <(_ left: Element, _ right: Element) -> Bool {
        compare(left, right) == 2
    }
    
    static func compare(_ left: Element, _ right: Element) -> Int {
        switch (left, right) {
            case (.value(let value1), .value(let value2)):
                return compare(value1, value2)
            default:
                return compare(left.elements, right.elements)
        }
    }
    
    private static func compare(_ left: Int, _ right: Int) -> Int {
        left > right ? 0 : left == right ? 1 : 2
    }
    
    private static func compare(_ left: [Element], _ right: [Element]) -> Int {
        for index in left.indices {
            guard right.count > index else { return 0 }
            let cmp = compare(left[index], right[index])
            if cmp != 1 { return cmp }
        }
        return right.count > left.count ? 2 : 1
    }
}

func readPacket(_ raw: String) -> Element {
    var stack: [[Element]] = []
    var currentValue = ""
    
    func appendValue() {
        guard currentValue != "", 
            let value = Int(currentValue) else { return }
        stack[stack.count-1] += [.value(value)]
        currentValue = ""
    }
    
    for char in raw {
        switch char {
            case "[":
                stack.append([])
            case "]":
                appendValue()
                if stack.count == 1 { break }
                let elements = stack.removeLast()
                stack[stack.count-1] += [Element.list(elements)]
            case ",":
                appendValue()
            default:
                currentValue.append(char)
        }
    }
    return .list(stack.removeLast())
}

func readPacket() -> Element? {
    guard let line = readLine() else { return nil }
    return readPacket(line)
}

func readPair() -> (Element, Element)? {
    guard let packet1 = readPacket(),
        let packet2 = readPacket()  else { return nil }
    _ = readLine()
    return (packet1, packet2)
}

var sum = 0
for index in (1...Int.max) {
    guard let (packet1, packet2) = readPair() else { break }
    if packet1 < packet2 {
        sum += index
    }
}
print(sum)
