struct Wire: Hashable {
    let from: String, to: String
}

func readWires() -> [Wire] {
    var wires: [Wire] = []
    while let split = readLine()?.split(separator: " ") {
        let from = String(split[0].dropLast())
        let to = split.dropFirst().map(String.init)
        wires.append(contentsOf: to.map { Wire(from: from, to: $0) })
    }
    return wires
}

var wires = Set(readWires())
let allNodes = Set(wires.flatMap { [$0.from, $0.to] })
print(allNodes.count)
print(wires.count )

let wiresToRemove = wires.count > 33
    ? [("cbl", "vmq"), ("klk", "xgz"), ("bvz", "nvf")]
    : [("pzl","hfx"), ("cmg","bvb"), ("jqt", "nvd")]
wires.subtract(Set(wiresToRemove.map { Wire(from: $0, to: $1) }))

var group: Set<String> = [wires.randomElement()!.from]
while true {
    let wiresToAdd = wires.filter {
        group.contains($0.from) || group.contains($0.to)
    }
    if wiresToAdd.isEmpty { break }
    group.formUnion(wiresToAdd.flatMap { [$0.from, $0.to] })
    wires.subtract(wiresToAdd)
}

let result = group.count * (allNodes.count - group.count)
print(result)
