typealias Step = (label: String, length: Int?)
typealias Lens = (label: String, length: Int)

func step(_ string: String.SubSequence) -> Step {
    switch string.last! {
        case "-":
            (label: String(string.dropLast()) , length: nil)
        default:
            (label: String(string.dropLast(2)), length: Int(String(string.last!))!)
    }
}

func readSteps() -> [Step] {
    readLine()!.split(separator: ",").map(step)
}

func ascii(_ char: Character) -> Int {
    Int(char.asciiValue!)
}

func hash(_ step: String) -> Int {
    step.reduce(0) { acc, char in
        ((acc + ascii(char)) * 17) % 256
    }
}

var boxes = [[Lens]](repeating: [], count: 256)
for (label, length) in readSteps() {
    let index = hash(label)
    let slot = boxes[index].firstIndex { $0.label == label }
    if let slot {
        boxes[index].remove(at: slot)
    }
    if let length {
        let lens = (label: label, length: length)
        boxes[index].insert(lens, at: slot ?? boxes[index].count)
    }
}

let result = boxes.enumerated().flatMap { index, box -> [Int] in
    box.enumerated().map { slot, lens in
        (index + 1) * (slot + 1) * lens.length
    }
}.reduce(0, +)
print(result)