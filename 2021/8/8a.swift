var counter = 0
while let line = readLine() {
    let output: [String] = line.split(separator: "|")[1].split(separator: " ").map(String.init)
    counter += output.filter { [2, 4, 3, 7].contains($0.count) }.count	
}
print(counter)
