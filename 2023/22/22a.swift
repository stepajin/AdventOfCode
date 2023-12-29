struct Block: Equatable {
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
}

let disintegratableBlock = placedBlocks.filter { block in
    let blocksAbove = placedBlocks.filter {
        $0.z.lowerBound == block.z.upperBound+1
            && xyIntersects(block, $0)
    }
    if blocksAbove.count == 0 { return true }
    let blocksAligned = placedBlocks.filter {
        $0.z.upperBound == block.z.upperBound
            && $0 != block
    }
    return blocksAbove.allSatisfy { above in
        blocksAligned.contains { xyIntersects(above, $0) }
    }
}

let result = disintegratableBlock.count
print(result)
