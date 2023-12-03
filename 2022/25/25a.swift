
func base10Digit(_ value: Character) -> Int64 {
    switch value {
        case "2": return 2
        case "1": return 1
        case "0": return 0
        case "-": return -1
        case "=": return -2
        default: return 0
    }
}

func base10(_ snafu: String) -> Int64 {
    var powerOf5: Int64 = 1
    return snafu
        .reversed()
        .map {
            let digit = base10Digit($0) * powerOf5
            powerOf5 *= 5
            return digit
        }.reduce(0, +)
}

func base5(_ base10: Int64) -> String {
    String(base10, radix: 5)
}

func snafu(_ base5: String) -> String {
    let digits = base5.map(String.init).compactMap(Int.init)
    var snafu = ""
    var carry = 0
    for digit in digits.reversed() {
        switch digit + carry {
            case 0...2:
                snafu.append(String(digit+carry))
                carry = 0
            case 3:
                snafu.append("=")
                carry = 1
            case 4:
                snafu.append("-")
                carry = 1
            case 5:
                snafu.append("0")
                carry = 1
            default:
                continue
        }
    }
    if carry == 1 {
        snafu.append("1")
    }
    return String(snafu.reversed())
}

func snafu(_ base10: Int64) -> String {
    snafu(base5(base10))
}

var sum: Int64 = 0
while let snafu = readLine() {
    sum += base10(snafu)
}
let result = snafu(sum)
print(result)
