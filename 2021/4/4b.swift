typealias Line = [Int?]
typealias Bingo = [Line]
extension Line {
    func marked(_ i: Int?) -> Line { map { $0 == i ? nil : $0 } }
    var value: Int { compactMap { $0 }.reduce(0, +) }
    var isMarked: Bool { allSatisfy { $0 == nil } }
}
extension Bingo {
    func row(_ r: Int) -> Line { self[r] }
    func column(_ c: Int) -> Line { (0..<count).map { self[$0][c] } }
    func marked(_ i: Int) -> Bingo { map { $0.marked(i) } }
    var rows: [Line] { self }
    var columns: [Line] { (0..<count).map { column($0) } }
    var value: Int { rows.map { $0.value }.reduce(0, +) }
    var isMarked: Bool { rows.contains { $0.isMarked } || columns.contains { $0.isMarked } }
}

guard var numbers: [Int] = readLine()?
.split(separator: ",").map(String.init).compactMap(Int.init) else { fatalError() }

var bingos: [Bingo] = []
while readLine() != nil {
    let bingo: Bingo = (1...5).compactMap { _ in 
        readLine()?.split(separator: " ").map(String.init).compactMap(Int.init) 
    }
    bingos.append(bingo)
}

while !numbers.isEmpty {
    let number = numbers.removeFirst()
    bingos = bingos.map { $0.marked(number) }
    let unmarkedBingos = bingos.filter { !$0.isMarked }
    if unmarkedBingos.isEmpty {
        guard let bingo = bingos.last else { break }
        print(number * bingo.value)
        break
    }
    bingos = unmarkedBingos
}
