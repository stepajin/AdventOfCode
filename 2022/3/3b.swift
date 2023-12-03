typealias Bag = [Character]

func priority(_ item: Character) -> Int {
    let ascii = Int(item.asciiValue ?? 0)
    switch ascii {
        case 97...122: return ascii - 96
        case 65...90: return ascii - 38
        default:  return 0
    }
}

func readBag() -> Bag? {
    readLine().map(Array<Character>.init)
}

func readGroup() -> [Bag]? {
    let bags = (1...3).compactMap { _ in readBag() }
    return bags.count == 3 ? bags : nil
}

func commonItem(_ bags: [Bag]) -> Character? {
    bags.dropFirst()
        .map(Set<Character>.init)
        .reduce(Set(bags[0])) { $0.intersection($1) }
        .first
}

var count = 0
while let bags = readGroup() {
    guard let item = commonItem(bags) else { continue }
    count += priority(item)
}

print(count)
