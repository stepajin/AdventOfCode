extension Array {
    mutating func push(_ value: Element) { insert(value, at: 0) }
    mutating func pop() -> Element? { isEmpty ? nil : removeFirst() }
}

let openingBrackets: [Character: Character] = [")": "(", "]": "[", "}": "{", ">": "<"]
let scoreValues: [Character: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137] 

var score = 0
while let line = readLine() {
    var stack: [Character] = []
    for bracket in line {
        if let opening = openingBrackets[bracket] {
            if opening != stack.pop() {
                score += scoreValues[bracket]!
                break
            }
        } else {
            stack.push(bracket)
        }
    }
}
print(score)
