
typealias Bag = ([Character], [Character])

func priority(_ item: Character) -> Int {
    let ascii = Int(item.asciiValue ?? 0)
    switch ascii {
        case 97...122: return ascii - 96
        case 65...90: return ascii - 38
        default:  return 0
    }
}

func readBag() -> Bag? {
    guard let bag = readLine() else { return nil }
    let count = bag.count
    return (Array(bag.prefix(count/2)), Array(bag.suffix(count/2)))
}

func commonItem(_ bag: Bag) -> Character? {
    Set(bag.0).intersection(Set(bag.1)).first
}

var count = 0
while let bag = readBag() {
    guard let item = commonItem(bag) else { continue }
    count += priority(item)
}

print(count)
