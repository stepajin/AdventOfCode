struct Block: Equatable, Hashable {
    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>
}

func readBlocks() -> [Block] {
    var blocks: [Block] = []
    while let coord = readLine()?.split(separator: "~").map({
        $0.split(separator: ",").map(String.init).compactMap(Int.init)
    }) {
        blocks.append(Block(
            x: coord[0][0]...coord[1][0],
            y: coord[0][1]...coord[1][1],
            z: coord[0][2]...coord[1][2]
        ))
    }
    return blocks
}

func intersects(_ range: ClosedRange<Int>, _ range2: ClosedRange<Int>) -> Bool {
    let clamped = range.clamped(to: range2)
    return range.contains(clamped.lowerBound)
}

func xyIntersects(_ block1: Block, _ block2: Block) -> Bool {
    intersects(block1.x, block2.x) && intersects(block1.y, block2.y)
}

func containsAll(_ blocks: Set<Block>, _ blocks2: [Block]) -> Bool {
    !blocks2.isEmpty && blocks2.allSatisfy { blocks.contains($0) }
}

let ground = Block(
    x: 0...(.max),
    y: 0...(.max),
    z: 0...0
)
let blocks: [Block] = readBlocks().sorted { $0.z.lowerBound <= $1.z.lowerBound }
let placedBlocks: [Block] = blocks.reduce(into: [ground]) { blocks, block in
    let blockBelow = blocks.reversed().first { xyIntersects($0, block) }!
    let droppedBlock = Block(
        x: block.x,
        y: block.y,
        z: blockBelow.z.upperBound+1...blockBelow.z.upperBound+block.z.count
    )
    let index = blocks
        .lastIndex { $0.z.upperBound <= droppedBlock.z.upperBound }
        .map { $0 + 1 } ?? blocks.endIndex
    blocks.insert(droppedBlock, at: index)
}.filter { $0 != ground }

let supportedBy = [Block: [Block]](uniqueKeysWithValues: placedBlocks.map { block in
    let values = placedBlocks.filter {
        $0.z.upperBound == block.z.lowerBound-1 && xyIntersects(block, $0)
    }
    return (block, values)
})
    
func isSupported(_ block: Block, by blocks: Set<Block>) -> Bool {
    containsAll(blocks, supportedBy[block]!)
}

func blocksSupported(_ blocks: Set<Block>, by byBlocks: Set<Block>) -> Set<Block> {
    let supported = blocks.filter { isSupported($0, by: byBlocks) }
    if supported.count == 0 { return byBlocks }
    return blocksSupported(
        blocks.subtracting(supported),
        by: byBlocks.union(supported)
    )
}

func blocksSupported(by block: Block) -> Set<Block> {
    blocksSupported(
        Set(placedBlocks).subtracting([block]),
        by: Set([block])
    )
}

let result = placedBlocks
    .map { blocksSupported(by: $0).count - 1 }
    .reduce(0, +)

print(result)
