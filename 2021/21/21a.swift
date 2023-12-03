struct Player: Hashable {
    let position: Int
    let score: Int
    
    func moved(by steps: Int) -> Player {
        let sum = position + (steps % 10)
        let newPosition = sum > 10 ? sum - 10 : sum
        return Player(position: newPosition, score: score + newPosition)
    }
}

func readPosition() -> Int {
    Int(String(readLine()!.split(separator: " ").last!))!
}

var player1 = Player(position: readPosition(), score: 0)
var player2 = Player(position: readPosition(), score: 0)
var rollsCount = 0

func play(player: Int) -> Bool {
    let steps = 3 * rollsCount + 6
    rollsCount += 3
    if player == 1 {
        player1 = player1.moved(by: steps)
        return player1.score >= 1000
    } else {
        player2 = player2.moved(by: steps)
        return player2.score >= 1000
    }
}

while true {
    if play(player: 1) || play(player: 2) { break }
}

print(min(player1.score, player2.score) * rollsCount)
