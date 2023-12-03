func readValue() -> Int? { Int(readLine() ?? "") }

var values: [Int] = [readValue(), readValue(), readValue()].map { $0 ?? 0 }
var counter = 0
while let value = readValue() {
    if value > values[0] {
        counter += 1
    }
    values = [values[1], values[2], value]
}
print(counter)
