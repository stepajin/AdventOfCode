
func readTrees() -> [[Int]] {
    var trees: [[Int]] = []
    while let line = readLine() {
        trees.append(line.map(String.init).compactMap(Int.init))
    }
    return trees
}

let trees = readTrees()
let size = trees.count
var isVisible = [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)

func loop(from: Int, through: Int, by: Int, _ closure: (Int) -> (Int, Int)) {
    var max = -1
    for i in stride(from: from, through: through, by: by) {
        let index = closure(i)
        let height = trees[index.0][index.1]
        if max < height {
            isVisible[index.0][index.1] = true
            max = height
        }
    }
}

for index in trees.indices {
    loop(from: 0, through: size-1, by: 1) { (index, $0) }
    loop(from: size-1, through: 0, by: -1) { (index, $0) }
    loop(from: 0, through: size-1, by: 1) { ($0, index) }
    loop(from: size-1, through: 0, by: -1) { ($0, index) }
}

let result = isVisible.flatMap { $0.map { $0 ? 1 : 0 } }.reduce(0, +)
print(result)
