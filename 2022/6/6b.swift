
let length = 14
let input = Array(readLine()!)

var counts: [Character: Int] = [:]
var unique = 0

for idx in input.indices {
    counts[input[idx], default: 0] += 1
    if counts[input[idx]] == 1 {
        unique += 1
    }
    
    if idx >= length {
        counts[input[idx-length], default: 1] -= 1
        if counts[input[idx-length]] == 0 {
            unique -= 1
        }
    }
    
    if unique == length {
        print(idx+1)
        break
    }
}
