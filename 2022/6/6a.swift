
let length = 4
let input = Array(readLine()!)

let index = input.indices.dropFirst(length-1).first {
    Set(input[$0-length+1...$0]).count == length
}!

print(index+1)
