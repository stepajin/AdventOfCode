let template: [Character] = Array(readLine()!)
var edges = [String: Int](template.indices.dropLast().map {
    ("\(template[$0])\(template[$0+1])", 1)
}, uniquingKeysWith: +)

_ = readLine()!
var rules: [(String, String, String)] = []
while let line = readLine()?.split(separator: " ").map(String.init) {
    rules.append((line[0], "\(line[0].first!)\(line[2])", "\(line[2])\(line[0].last!)"))
}

for _ in (1...40) {
    let originalEdges = edges
    for rule in rules {
        let edgeCount = originalEdges[rule.0, default: 0]
        edges[rule.1] = edges[rule.1, default: 0] + edgeCount
        edges[rule.2] = edges[rule.2, default: 0] + edgeCount
        edges[rule.0] = edges[rule.0, default: 0] - edgeCount
    }
}

let counts = [Character: Int](edges.map { 
    ($0.key.first!, $0.value) 
} + [(template.last!, 1)], uniquingKeysWith: +)
print(counts.values.max()! - counts.values.min()!)
