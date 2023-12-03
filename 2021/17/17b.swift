typealias Coordinate = (Int, Int)
typealias Area = (ClosedRange<Int>, ClosedRange<Int>)

let input = readLine()!.split(separator: " ").map(String.init)
let xBounds = input[2].split(separator: "=")[1].dropLast().split(separator: ".").map(String.init).compactMap(Int.init)
let yBounds = input[3].split(separator: "=")[1].split(separator: ".").map(String.init).compactMap(Int.init)
let xRange = (xBounds[0]...xBounds[1])
let yRange = (yBounds[0]...yBounds[1])
let target = (xRange, yRange)

func contains(_ area: Area, _ coordinate: Coordinate) -> Bool {
	area.0 ~= coordinate.0 && area.1 ~= coordinate.1
}

func isBehind(_ coordinate: Coordinate, _ area: Area) -> Bool {
	coordinate.0 > target.0.upperBound || coordinate.1 < target.1.lowerBound
}

func trajectory(velocity startVelocity: Coordinate, target: Area) -> [Coordinate]? {
	var velocity = startVelocity
	var coordinate = (0, 0)
	var coordinates: [Coordinate] = []
	while !isBehind(coordinate, target) {
		coordinates.append(coordinate)
		if contains(target, coordinate) {
			return coordinates
		}
		coordinate = (coordinate.0 + velocity.0, coordinate.1 + velocity.1)
		velocity = (max(0, velocity.0-1), velocity.1-1)
	}
	return nil
}

let velocities = (0...xRange.upperBound).flatMap { x in (yRange.lowerBound...1000).map { (x, $0) } }
let possibleVelocities = velocities.filter { trajectory(velocity: $0, target: target) != nil }
print(possibleVelocities.count)
