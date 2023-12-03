var bitCounts: [Int] = []
var inputCount = 0

while let input = readLine() {
    if bitCounts.isEmpty {
        bitCounts = [Int](repeating: 0, count: input.count)
    }
    let bits = input.map(String.init).compactMap(Int.init)
    bitCounts = (0..<bitCounts.count).map { bitCounts[$0] + bits[$0] }
    inputCount += 1
}

let gammaBinary: String = bitCounts.map { $0 >= inputCount-$0 ? "1" : "0" }.joined()
let epsilonBinary: String = gammaBinary.map { $0 == "1" ? "0" : "1" }.joined()

guard let gamma = Int(gammaBinary, radix: 2),
let epsilon = Int(epsilonBinary, radix: 2) else { fatalError() }

print(gamma * epsilon)
