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

typealias Round = (Choice, Int)

func readRound() -> Round? {
    guard let ascii = readLine()?.compactMap(\.asciiValue).map(Int.init) else { return nil }
    return (Choice(ascii[0] - 65), ascii[2] - 88)
}

func selectChoice(for result: Int, against other: Choice) -> Choice {
    switch result {
        case 0: return other.previous
        case 1: return other
        default: return other.next
    }
}

func countScore(_ round: Round) -> Int {
    round.1 * 3 + selectChoice(for: round.1, against: round.0).rawValue + 1
}

var score = 0
while let round = readRound() {
    score += countScore(round)
}
print(score)
