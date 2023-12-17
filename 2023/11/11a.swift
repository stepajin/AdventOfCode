
typealias Image = [[Character]]
typealias Index = (x: Int, y: Int)

func readImage() -> Image {
    var image: Image = []
    while let line = readLine() {
        image.append(Array(line))
    }
    return image
}

func galaxyIndices(_ image: Image) -> [Index] {
    image.indices.flatMap { y in
        image[y].indices.lazy.map { x in
            (x: x, y: y)
        }.filter { x, y in
            image[y][x] == "#"
        }
    }
}

func expandedGalaxyIndices(_ image: Image) -> [Index] {
    let galaxies = galaxyIndices(image)
    let emptyRows = Set(image.indices).subtracting(
        Set(galaxies.map { $0.y })
    )
    let emptyColumns = Set(image[0].indices).subtracting(
        Set(galaxies.map { $0.x })
    )
    return galaxyIndices(image).map { x, y in
        Index(
            x: x + emptyColumns.filter { $0 < x }.count,
            y: y + emptyRows.filter { $0 < y }.count
        )
    }
}

func distance(_ index1: Index, _ index2: Index) -> Int {
    abs(index1.x - index2.x) + abs(index1.y - index2.y)
}

let image = readImage()
let galaxies = expandedGalaxyIndices(image)

let result = galaxies.indices.flatMap { index1 in
    galaxies.indices.filter { index2 in
        index2 > index1
    }.map { index2 in
        distance(galaxies[index1], galaxies[index2])
    }
}.reduce(0, +)

print(result)