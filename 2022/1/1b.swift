func readValue() -> Int? {
    Int(readLine() ?? "")
}

func readCalories() -> Int? {
    guard var total = readValue() else { return nil }
    while let value = readValue() { total += value }
    return total
}

var topThree = [0, 0, 0]
while let calories = readCalories() {
    if calories > topThree[0] {
        topThree[0] = calories
        topThree.sort()
    }
}

let total = topThree.reduce(0, +)
print(total)
