func mostCommonBit(at index: Int, _ inputs: [[Int8]]) -> Int8 {
    let count = inputs.map { Int($0[index]) }.reduce(0, +)
    return count >= inputs.count - count ? 1 : 0
}

var inputs: [[Int8]] = []
while let input = readLine() {
    inputs.append(input.map(String.init).compactMap(Int8.init))
}
guard let length = inputs.first?.count else { fatalError() } 

let oxygenBits: [Int8] = (0..<length).reduce(inputs) { inputs, idx in
    guard inputs.count > 1 else { return inputs }
    let mcb = mostCommonBit(at: idx, inputs)
    return inputs.filter { $0[idx] == mcb } 
}.first ?? []

let co2Bits: [Int8] = (0..<length).reduce(inputs) { inputs, idx in
    guard inputs.count > 1 else { return inputs }
    let mcb = mostCommonBit(at: idx, inputs)
    return inputs.filter { $0[idx] != mcb } 
}.first ?? []

let oxygenBinary: String = oxygenBits.map(String.init).joined()
let co2Binary: String = co2Bits.map(String.init).joined()

guard let oxygen = Int(oxygenBinary, radix: 2),
let co2 = Int(co2Binary, radix: 2) else { fatalError() }

print(oxygen * co2)
