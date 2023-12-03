struct Player: Hashable {
    let position: Int
    let score: Int
    
    func moved(by steps: Int) -> Player {
        let sum = position + steps
        let newPosition = sum > 10 ? sum - 10 : sum
        return Player(position: newPosition, score: score + newPosition)
    }
}

struct State: Hashable {
    let player1: Player
    let player2: Player
    var player1Wins: Bool { player1.score >= 21 }
    var player2Wins: Bool { player2.score >= 21 }
}

let rolls: [Int] = (1...3).flatMap { a in (1...3).flatMap { b in (1...3).map { c in a + b + c } } }
let rollCounts: [UInt64] = (0...9).map { roll in UInt64(rolls.filter { $0 == roll }.count) }

func readPosition() -> Int {
    Int(String(readLine()!.split(separator: " ").last!))!
}

let initialState = State(
    player1: Player(position: readPosition(), score: 0),
    player2: Player(position: readPosition(), score: 0)
)

var player1Wins: UInt64 = 0
var player2Wins: UInt64 = 0
var states: [State: UInt64] = [initialState: 1]

func play(player: UInt8) -> Bool {
    var nextStates: [State: UInt64] = [:]
    for (state, count) in states {
        for roll in (3...9) {
            let nextState = State(
                player1: player == 1 ? state.player1.moved(by: roll) : state.player1,
                player2: player == 2 ? state.player2.moved(by: roll) : state.player2
            )
            let nextStateCount = rollCounts[roll] * count
            if nextState.player1Wins {
                player1Wins += nextStateCount
            } else if nextState.player2Wins {
                player2Wins += nextStateCount
            } else {
                nextStates[nextState, default: 0] += nextStateCount
            }
        }
    }
    states = nextStates
    return states.isEmpty
}

while true {
    if play(player: 1) || play(player: 2) { break }
}

print(max(player1Wins, player2Wins))
