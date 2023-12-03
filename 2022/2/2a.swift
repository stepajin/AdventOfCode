enum Choice: Int, Comparable {
    case rock = 0, paper, scissors
    
    init(_ value: Int) {
        let modulo = value % 3
        self.init(rawValue: modulo < 0 ? modulo + 3 : modulo)!
    }
    
    var next: Choice { Choice(rawValue + 1) }
    var previous: Choice { Choice(rawValue - 1) }
    
    static func <(_ a: Choice, _ b: Choice) -> Bool {
        a.next == b
    }
}

typealias Round = (Choice, Choice)

func readRound() -> Round? {
    guard let ascii = readLine()?.compactMap(\.asciiValue).map(Int.init) else { return nil }
    return (Choice(ascii[0] - 65), Choice(ascii[2] - 88))
}

func compare(_ round: Round) -> Int {
    switch round {
        case let (a, b) where b > a: return 2
        case let (a, b) where b == a: return 1
        default: return 0
    }
}

func countScore(_ round: Round) -> Int {
    compare(round) * 3 + round.1.rawValue + 1
}

var score = 0
while let round = readRound() {
    score += countScore(round)
}
print(score)
