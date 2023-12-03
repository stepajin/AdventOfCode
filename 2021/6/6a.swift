guard let input = readLine()?.split(separator: ",").map(String.init).compactMap(Int.init) else { fatalError() }

var timers = [Int](repeating: 0, count: 9)
for i in input { timers[i] += 1 }

for _ in (1...80) {
    timers = timers.dropFirst() + [timers[0]]
    timers[6] += timers[8]
}

let count = timers.reduce(0, +)
print(count)
