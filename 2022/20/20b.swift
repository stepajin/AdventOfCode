
class Node {
    let value: Int
    var next: Node!
    var previous: Node!

    init(value: Int) {
        self.value = value
    }

    func move(_ i: Int) -> Node! {
        guard i != 0 else { return self }
        return i > 0 ? next.move(i-1) : previous.move(i+1)
    }
}

var nodes: [Node] = []
while let raw = readLine(),
    let value = Int(raw) {
    let node = Node(value: value * 811589153)
    node.previous = nodes.last
    nodes.last?.next = node
    nodes.append(node)
}
nodes.last?.next = nodes.first
nodes.first?.previous = nodes.last

for _ in 1...10 {
    for node in nodes {
        guard node.value != 0 else { continue }

        let prev: Node = node.previous
        let next: Node = node.next
        prev.next = next
        next.previous = prev

        var left: Node
        var right: Node

        if node.value > 0 {
            left = next.move((node.value - 1) % (nodes.count - 1))
            right = left.next
        } else {
            right = prev.move(-(abs(node.value + 1) % (nodes.count - 1)))
            left = right.previous
        }

        left.next = node
        node.previous = left

        right.previous = node
        node.next = right
    }
}

let zero = nodes.first { $0.value == 0 }!
let result = zero.move(1000).value
    + zero.move(2000).value
    + zero.move(3000).value
print(result)
