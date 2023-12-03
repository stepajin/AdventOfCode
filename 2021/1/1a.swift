func readValue() -> Int? { Int(readLine() ?? "") }

var lastValue = readValue() ?? 0
var counter = 0
while let value = readValue() {
    if value > lastValue {
        counter += 1
    }
    lastValue = value
}
print(counter)
