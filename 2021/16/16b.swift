func padded(_ str: String, to length: Int, with char: Character) -> String {
    String((0..<length-str.count).map { _ in char }) + str
}
func decimal(_ hex: Character) -> Int { Int("\(hex)", radix: 16)! }
func decimal(_ binary: String) -> Int { Int(binary, radix: 2)! }
func binary(_ dec: Int) -> String { padded(String(dec, radix: 2), to: 4, with: "0") }
func binary(_ hex: Character) -> String { binary(decimal(hex)) }
func binary(_ str: String) -> String { str.map(binary(_:)).joined() }
func bits(_ str: String) -> [Character] { Array(binary(str)) }
func number(_ bits: [Character]) -> Int { decimal(String(bits)) }
func number(_ bits: Array<Character>.SubSequence) -> Int { decimal(String(bits)) }

func parseBits(_ bits: inout [Character], _ length: Int) -> [Character] {
    let parsed = Array(bits[0..<length])
    bits.removeFirst(length)
    return parsed
}

func parseNumber(_ bits: inout [Character], length: Int) -> Int {
    number(parseBits(&bits, length))	
}

enum PacketTypeId: Int {
    case sum = 0
    case product = 1
    case minimum = 2
    case maxiumum = 3
    case literalValue = 4
    case greater = 5
    case less = 6
    case equal = 7
}

enum PacketType {
    case value(Int)
    case op([Packet])
}

struct Packet {
    let version: Int
    let typeId: PacketTypeId
    let type: PacketType
}

func parseValue(_ bits: inout [Character]) -> Int {
    var groups: [[Character]] = []
    while groups.last?.first != "0" {
        groups.append(parseBits(&bits, 5))
    }
    let binary = groups.flatMap { $0.dropFirst() }
    return number(binary)
}

func parseSubpackets(_ bits: inout [Character]) -> [Packet] {
    let lengthId = parseNumber(&bits, length: 1)
    var subpackets: [Packet] = []
    if lengthId == 0 {
        let subpacketsLength = parseNumber(&bits, length: 15)
        let endLength = bits.count - subpacketsLength
        while bits.count > endLength {
            subpackets.append(parsePacket(&bits))
        }
    } else {
        let subpacketsCount = parseNumber(&bits, length: 11)
        for _ in stride(from: subpacketsCount, to: 0, by: -1) {
            subpackets.append(parsePacket(&bits))			
        }
    }
    return subpackets
}

func parsePacket(_ bits: inout [Character]) -> Packet {
    let version = parseNumber(&bits, length: 3)
    let typeId = PacketTypeId(rawValue: parseNumber(&bits, length: 3))!
    let type: PacketType
    switch typeId {
    case .literalValue: type = .value(parseValue(&bits))
    default: type = .op(parseSubpackets(&bits))
    }
    return Packet(version: version, typeId: typeId, type: type)
}

func evaluateOperator(_ typeId: PacketTypeId, _ values: [Int]) -> Int {
    switch typeId {
    case .sum: return values.reduce(0, +)
    case .product: return values.reduce(1, *)
    case .minimum: return values.min()!
    case .maxiumum: return values.max()!
    case .literalValue: return 0
    case .greater: return values.dropFirst().allSatisfy { values[0] > $0 } ? 1 : 0
    case .less: return values.dropFirst().allSatisfy { values[0] < $0 } ? 1 : 0
    case .equal: return values.dropFirst().allSatisfy { values[0] == $0 } ? 1 : 0
    }
}

func evaluate(_ packet: Packet) -> Int {
    switch packet.type {
    case let .value(value): 
        return value
    case let .op(subpackets):
        let values = subpackets.map(evaluate(_:))
        return evaluateOperator(packet.typeId, values)
    }
}

var packetBits = bits(readLine()!)
let packet = parsePacket(&packetBits)
let value = evaluate(packet)
print(value)
