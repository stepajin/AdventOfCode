
func readTrees() -> [[Int]] {
    var trees: [[Int]] = []
    while let line = readLine() {
        trees.append(line.map(String.init).compactMap(Int.init))
    }
    return trees
}

let trees = readTrees()
let size = trees.count

func countScore(from: Int, through: Int, by: Int, _ closure: (Int) -> (Int, Int)) -> Int {
    guard from > 0 && from < size-1 else { return 0 }
    let index = closure(from)
    let height = trees[index.0][index.1]

    let blockingIndex = stride(from: from, through: through, by: by).dropFirst().first {
        let index = closure($0)
        return trees[index.0][index.1] >= height
    } ?? through

    return abs(from - blockingIndex)
}

var result = 0
for row in trees.indices {
    for column in trees[row].indices {
        let up = countScore(from: row, through: 0, by: -1) { ($0, column) }
        let left = countScore(from: column, through: 0, by: -1) { (row, $0) }
        let right = countScore(from: column, through: size-1, by: 1) { (row, $0) }
        let down = countScore(from: row, through: size-1, by: 1) { ($0, column) }
        let score = up * left * right * down
        if score > result {
            result = score
        }
    }
}
print(result)
