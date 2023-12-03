struct ALU {
    let p1: [Int64], p2: [Int64], p3: [Int64]
    let maxZ: [Int64]
    
    init(_ p1: [Int64], _ p2: [Int64], _ p3: [Int64]) {
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        maxZ = p1.reversed().reduce([]) { $0 + [$1 * ($0.last ?? 1)] }.reversed()
    }
    
    func search(_ n: Int, _ z: Int64, _ digits: inout [Int64]) -> Bool {
        if n == 14 { return z == 0 }
        guard z < maxZ[n] else { return false }
        
        for w in stride(from: 1 as Int64, through: 9, by: 1) {
            digits[n] = w
            let nextZ = w == z % 26 + p2[n] ? z / p1[n] : (z / p1[n]) * 26 + w + p3[n]
            if search(n + 1, nextZ, &digits) {
                return true
            }
        }
        return false
    }
    
    func solve() -> Int64 {
        var digits = [Int64](repeating: 0, count: 14)
        guard search(0, 0, &digits) else { return 0 }
        return Int64(digits.map(String.init).joined()) ?? 0
    }
}

func readALU() -> ALU {
    var lines: [String] = []
    while let line = readLine() {
        lines.append(line)
    }
    let instructions: [[Substring]] = lines.map { $0.split(separator: " ") }
    let values: (Int) -> [Int64] = { line in (0...13).map { instructions[line + $0 * 18] }.map { Int64(String($0[2]))! } }
    return ALU(values(4), values(5), values(15))
}

let alu = readALU()
print(alu.solve())
