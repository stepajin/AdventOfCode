typealias Bit = UInt8

func enhanceImage(_ image: [[Bit]], _ algorithm: [Bit], paddingBit: Bit) -> [[Bit]] {
    (-1...image.count).map { row -> [Bit] in
        (-1...image[0].count).map { column -> Bit in
            let indices: [(Int, Int)] = (-1...1).flatMap { r in (-1...1).map { c in (row+r, column+c) } }
            let binary: String = indices.map { r, c -> Bit in
                image.indices ~= r && image[r].indices ~= c 
                    ? image[r][c]
                    : paddingBit
            }.map(String.init).joined()
            let index = Int(binary, radix: 2)!
            return algorithm[index]
        }
    }
}

func paddingBit(_ algorithm: [Bit], _ step: Int) -> Bit {
    switch (algorithm[0], algorithm[511]) {
    case (1, 1) where step >= 2,
         (1, 0) where step % 2 == 0: 
        return 1
    default:
        return 0
    }
}

func bit(_ char: Character) -> Bit { 
    char == "#" ? 1 : 0 
}

let algorithm: [Bit] = readLine()!.map(bit(_:))
_ = readLine()!
var input: [[Bit]] = []
while let line = readLine()?.map(bit(_:)) {
    input.append(line)
}

let image = (1...2).reduce(input) { image, step in
    enhanceImage(image, algorithm, paddingBit: paddingBit(algorithm, step))
}

let count = image.flatMap { $0 }.map(Int.init).reduce(0, +)
print(count)
