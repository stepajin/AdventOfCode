func intersection(_ a: String, _ b: String) -> String {
    String(Set(a).intersection(Set(b)))
}
func subtract(_ a: String, _ b: String) -> String {
    String(Set(a).subtracting(Set(b)))
}

func readIO() -> ([String], [String])? {
    guard let line = readLine() else { return nil }
    let split = line.split(separator: "|")
    let input: [String] = split[0].split(separator: " ").map(String.init)
    let output: [String] = split[1].split(separator: " ").map(String.init)
    return (input, output)
}

func filter(_ options: [Character: String], segments: String, mapped: String) -> [Character: String] {
    [Character: String](uniqueKeysWithValues: options.map { key, value -> (Character, String) in
        segments.contains(key)
            ? (key, intersection(value, mapped))
            : (key, subtract(value, mapped))
    })
}

let segments: [String] = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

var result = 0
while let (inputs, outputs) = readIO() { 
    var options = [Character: String](uniqueKeysWithValues: Array("abcdefg").map { ($0, "abcdefg") })
    var sortedInputs = inputs.sorted { $0.count <= $1.count }
    
    for digit in [1, 7, 4, 2, 3, 5, 6, 9, 0, 8] {
        for (index, input) in sortedInputs.enumerated() { 
            let filtered = filter(options, segments: segments[digit], mapped: input)
            guard filtered.values.allSatisfy({ !$0.isEmpty }) else { continue }
            sortedInputs.remove(at: index)
            options = filtered 
            break
        }
        if options.values.allSatisfy({ $0.count == 1 }) {
            break
        }
    }
    
    let map = [Character: Character](uniqueKeysWithValues: options.map { ($0.value.first!, $0.key) })
    let mappedOutputs: [String] = outputs.map {
        $0.map { map[$0]! }.sorted().map(String.init).joined()
    }
    let outputDigits: [Int] = mappedOutputs.map { segments.firstIndex(of: $0)! }
    let outputNumber: Int = outputDigits.reduce(0) { $0 * 10 + $1 }
    result += outputNumber
}
print(result)
