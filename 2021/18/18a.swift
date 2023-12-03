func floor(_ double: Double) -> Int { Int(double) }
func ceil(_ double: Double) -> Int { double - Double(Int(double)) == 0 ? Int(double) : Int(double) + 1 }

indirect enum Element {
    case value(Int)
    case pair(Pair)
}

class Node: CustomDebugStringConvertible {
    var element: Element
    var debugDescription: String {
        switch element {
        case .value(let value): return "\(value)"
        case .pair(let pair): return "\(pair)"
        }
    }
    var firstValue: Node {    
        switch element {
        case .value: return self
        case .pair(let pair): return pair.firstValue
        }
    }
    var lastValue: Node {
        switch element {
        case .value: return self
        case .pair(let pair): return pair.lastValue
        }
    }
    var magnitude: Int {
        switch element {
        case .value(let value): return value
        case .pair(let pair): return pair.magnitude
        }
    }
    
    init(_ element: Element) { self.element = element }
    
    func add(_ value: Int) {
        guard case .value(let currentValue) = element else { return }
        element = .value(currentValue + value)
    }
    
    func explode(depth: Int) -> (left: Int?, right: Int?)? {
        switch self.element {
        case .value: 
            return nil
        case .pair(var pair):
            if depth >= 4, 
                case let .value(leftValue) = pair.left.element, 
                case let .value(rightValue) = pair.right.element {
                self.element = .value(0)
                return (leftValue, rightValue)
            } else {
                return pair.explode(depth: depth)
            }
        }
    }
    
    func split() -> Bool {
        switch self.element {
        case .value(let value) where value >= 10:
            let left = Element.value(floor(Double(value)/2))
            let right = Element.value(ceil(Double(value)/2))
            self.element = .pair(Pair(left: Node(left), right: Node(right)))
            return true
        case .value:
            return false
        case .pair(var pair): 
            return pair.split()
        }
    }
}

struct Pair: CustomDebugStringConvertible {
    let left: Node
    let right: Node
    var debugDescription: String { "[\(left),\(right)]" }
    var firstValue: Node { left.firstValue }
    var lastValue: Node { right.lastValue }
    var magnitude: Int { 3 * left.magnitude + 2 * right.magnitude }
    
    init(_ raw: String) {
        func parseElement(_ str: inout String) -> Element {
            if str.first == "[" {
                str.removeFirst()
                let left = parseElement(&str)
                str.removeFirst()
                let right = parseElement(&str)
                str.removeFirst()
                let pair = Pair(left: Node(left), right: Node(right))
                return .pair(pair)
            } else {
                let index = [str.firstIndex(of: ","), str.firstIndex(of: "]")].compactMap { $0 }.min()!
                let value = Int(str[str.startIndex..<index])!
                str = String(str[index..<str.endIndex])
                return .value(value)
            }
        }
        var s = raw
        guard case let .pair(pair) = parseElement(&s) else { fatalError() }
        self = pair
    }
    
    init(left: Node, right: Node) {
        self.left = left
        self.right = right
    }
    
    mutating func explode(depth: Int) -> (left: Int?, right: Int?)? {
        if let values = left.explode(depth: depth+1) {
            if let rightValue = values.right {
                right.firstValue.add(rightValue)
                return (values.left, nil)
            } else {
                return values
            }
        }
        if let values = right.explode(depth: depth+1) {
            if let leftValue = values.left {
                left.lastValue.add(leftValue)
                return (nil, values.right)
            } else {
                return values
            }
        }
        return nil
    }
    
    mutating func explode() -> Bool {
        explode(depth: 0) != nil
    }
    
    mutating func split() -> Bool {
        left.split() || right.split()
    }
    
    mutating func reduce() {
        while explode() || split() { }
    }
    
    func copy() -> Pair {
        Pair(debugDescription)
    }
    
    static func +(left: Pair, right: Pair) -> Pair {
        var pair = Pair(left: Node(.pair(left.copy())), right: Node(.pair(right.copy())))
        pair.reduce()
        return pair
    }
}

var pairs: [Pair] = []
while let line = readLine() { pairs.append(Pair(line)) }
let sum = pairs.dropFirst().reduce(pairs[0], +)
print(sum.magnitude)
