func readValue() -> Int? {
    Int(readLine() ?? "")
}

func readCalories() -> Int? {
    guard var total = readValue() else { return nil }
    while let value = readValue() { total += value }
    return total
}

var maxCalories = 0
while let calories = readCalories() {
    if calories > maxCalories {
        maxCalories = calories
    }
}

print(maxCalories)
