
func readSteps() -> [String] {
    readLine()!.split(separator: ",").map(String.init)
}

func ascii(_ char: Character) -> Int {
    Int(char.asciiValue!)
}

func hash(_ step: String) -> Int {
    step.reduce(0) { acc, char in
        ((acc + ascii(char)) * 17) % 256
    }
}

let steps = readSteps()
let result = steps.map(hash(_:)).reduce(0, +)
print(result)
