import Foundation

let formatter = NumberFormatter()
formatter.numberStyle = .spellOut

func number(_ string: String) -> Int {
    formatter.number(from: string)?.intValue ?? Int(string) ?? 0
}

func firstMatch(_ string: String, of regex: Regex<AnyRegexOutput>) -> String {
    string.firstMatch(of: regex).map { String(string[$0.range]) } ?? ""
}

func reverse(_ string: String) -> String {
    String(string.reversed())
}

let numbers: [String] = (1...9).flatMap { [String($0), formatter.string(from: NSNumber(value: $0))!] }
let pattern = numbers.joined(separator: "|")
let regex = try! Regex(pattern)
let reversedRegex = try! Regex(reverse(pattern))

var sum = 0
while let line = readLine() {
    let match1 = firstMatch(line, of: regex)
    let match2 = reverse(firstMatch(reverse(line), of: reversedRegex))
    sum += number(match1) * 10 + number(match2)
}
print(sum)
