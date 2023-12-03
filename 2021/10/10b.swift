extension Array {
    mutating func push(_ value: Element) { insert(value, at: 0) }
    mutating func pop() -> Element? { isEmpty ? nil : removeFirst() }
}

let openingBrackets: [Character: Character] = [")": "(", "]": "[", "}": "{", ">": "<"]
let closingBrackets = [Character: Character](uniqueKeysWithValues: openingBrackets.map { ($1, $0) })
let scoreValues: [Character: Int] = [")": 1, "]": 2, "}": 3, ">": 4] 

var scores: [Int] = []
lineCheck: while let line = readLine() {
    var stack: [Character] = []
    for bracket in line {
        if let opening = openingBrackets[bracket] {
            if opening != stack.pop() {
                continue lineCheck
            }
        } else {
            stack.push(bracket)
        }
    }
    let autocompletedBrackets = stack.compactMap { closingBrackets[$0] }
    let score = autocompletedBrackets.compactMap { scoreValues[$0] }.reduce(0) { $0 * 5 + $1 }
    scores.append(score)
}

let middleScore = scores.sorted()[scores.count/2]
print(middleScore)
