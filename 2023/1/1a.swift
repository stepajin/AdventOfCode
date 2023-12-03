var sum = 0
while let line = readLine() {
    let digits: [Int] = line.map(String.init).compactMap(Int.init)
    sum += digits.first! * 10 + digits.last!
}
print(sum)
