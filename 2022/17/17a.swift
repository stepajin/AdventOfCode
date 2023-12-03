typealias Bitmap = UInt8

func printSpace(_ space: [Bitmap]) {
    space.lazy.map {
        let bin = String($0, radix: 2)
        let prefix = String([Character](repeating: "0", count: 7-bin.count))
        return "|" + (prefix + bin).map { $0 == "1" ? "#" : "."}.joined() + "|"
    }.forEach {
        Swift.print($0)
    }
}

struct Rock {
    let map: [Bitmap]
    let width: Int
    let height: Int
    
    func lines(offset: Int) -> [Bitmap] {
        let rightOffset = 7-width-offset
        return map.map { $0 << rightOffset }
    }
    
    func print() {
        printSpace(lines(offset: 2))
    }
}

let patterns =
"""
####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##
"""

let rocks: [Rock] = patterns
    .split(separator: "\n\n")
    .map { pattern -> Rock in
        let lines = pattern.split(separator: "\n")
        let bitmaps = lines
            .map { $0.map { $0 == "#" ? "1" : "0" }.joined() }
            .compactMap { Bitmap($0, radix: 2) }
        return Rock(
            map: bitmaps,
            width: lines[0].count,
            height: bitmaps.count
        )
    }

let jet: [Bool] = readLine()!.map { $0 == ">" }
let jetWidth = jet.count
var jetIndex = 0

var space: [UInt8] = [0b1111111]

var height = 0
var i = 0
let maxI = 2022

while i < maxI {
    let rock = rocks[i % rocks.count]
    
    let newLines = [Bitmap](repeating: 0b0000000, count: rock.height + 3)
    space = newLines + space
    
    var offset = 2
    var collisionIndex = 0
    var rockBottom = rock.height-1
    
    while collisionIndex == 0 {
        // SHIFT
        let direction = jet[jetIndex]
        jetIndex = (jetIndex + 1) % jet.count
                
        let tryOffset: Int = direction
            ? min(offset+1, 7-rock.width)
            : max(offset-1, 0)
        let shiftLines = rock.lines(offset: tryOffset)
        let canShift = shiftLines.indices.allSatisfy({
            let r = shiftLines[rock.height-1-$0]
            let s = space[rockBottom-$0]
            return r & s == 0
        })
        if canShift {
            offset = tryOffset
        }
        
        // FALL
        rockBottom += 1
        let rockLines = rock.lines(offset: offset)

        if rockLines.indices.contains(where: {
            let r = rockLines[rock.height-1-$0]
            let s = space[rockBottom-$0]
            return (r & s) > 0
        }) {
            collisionIndex = rockBottom
        }
    }
    
    // Merge
    let rockLines = rock.lines(offset: offset)
    rockLines.indices.forEach {
        let r = rockLines[rock.height-1-$0]
        let s = space[collisionIndex-1-$0]
        space[collisionIndex-1-$0] = s | r
    }
    
    // Trim
    let emptyPrefix = space.prefix(while: { $0 == 0 }).count
    space = Array(space.dropFirst(emptyPrefix))
    
    height += newLines.count - emptyPrefix
    i += 1
}

print(height)
