let maxTime = 32

struct Blueprint {
    let oreForOreRobot: Int
    let oreForClayRobot: Int
    let oreForObsidianRobot: Int
    let clayForObsidianRobot: Int
    let oreForGeodeRobot: Int
    let obsidianForGeodeRobot: Int
    
    var maxOreForRobot: Int {
        max(oreForOreRobot, oreForClayRobot, oreForObsidianRobot, oreForGeodeRobot)
    }
}

struct Resources: Hashable {
    let ore: Int
    let clay: Int
    let obsidian: Int
    let geodes: Int
}

struct Robots: Hashable {
    let oreRobots: Int
    let clayRobots: Int
    let obsidianRobots: Int
    let geodeRobots: Int
}

struct State {
    struct Hash: Hashable {
        let resources: Resources
        let robots: Robots
    }
    
    let time: Int
    let resources: Resources
    let robots: Robots

    var hash: Int {
        Hash(resources: resources, robots: robots).hashValue
    }
    
    var potentialGeodes: Int {
        let timeRemaining = maxTime-time
        return resources.geodes
            + timeRemaining * robots.geodeRobots
            + (0..<timeRemaining).reduce(0, +)
    }
}

func readBlueprint() -> Blueprint? {
    guard let n = readLine()?.split(separator: " ").map(String.init).compactMap(Int.init),
        n.count > 0 else { return nil }
    return Blueprint(
        oreForOreRobot: n[0],
        oreForClayRobot: n[1],
        oreForObsidianRobot: n[2],
        clayForObsidianRobot: n[3],
        oreForGeodeRobot: n[4], 
        obsidianForGeodeRobot: n[5]
    )
}

var blueprints: [Blueprint] = []
while blueprints.count < 3, let blueprint = readBlueprint() {
    blueprints.append(blueprint)
}

let initialState = State(
    time: 0,
    resources: Resources(
        ore: 0,
        clay: 0,
        obsidian: 0,
        geodes: 0
    ), robots: Robots(
        oreRobots: 1,
        clayRobots: 0,
        obsidianRobots: 0,
        geodeRobots: 0
    )
)

let totalQuality = blueprints.map { blueprint in
    let maxOreForRobot = blueprint.maxOreForRobot
    var stack = [initialState]
    var maxGeodes = 0
    var timeCache: [Int: Int] = [:]
    
    while !stack.isEmpty {
        let state = stack.removeLast()
        
        if state.time == maxTime {
            if state.resources.geodes > maxGeodes {
                maxGeodes = state.resources.geodes
            }
            continue
        }

        if state.potentialGeodes < maxGeodes {
            continue
        }
        
        if let time = timeCache[state.hash], time <= state.time {
            continue
        }
        timeCache[state.hash] = state.time
        
        let harvest = State(
            time: state.time + 1,
            resources: Resources(
                ore: state.resources.ore + state.robots.oreRobots,
                clay: state.resources.clay + state.robots.clayRobots,
                obsidian: state.resources.obsidian + state.robots.obsidianRobots,
                geodes: state.resources.geodes + state.robots.geodeRobots
            ),
            robots: state.robots
        )
        stack.append(harvest)
        
        if state.robots.oreRobots < maxOreForRobot,
            state.resources.ore >= blueprint.oreForOreRobot {
            let buildOreRobot = State(
                time: harvest.time,
                resources: Resources(
                    ore: harvest.resources.ore - blueprint.oreForOreRobot,
                    clay: harvest.resources.clay,
                    obsidian: harvest.resources.obsidian,
                    geodes: harvest.resources.geodes
                ),
                robots: Robots(
                    oreRobots: harvest.robots.oreRobots + 1,
                    clayRobots: harvest.robots.clayRobots,
                    obsidianRobots: harvest.robots.obsidianRobots,
                    geodeRobots: harvest.robots.geodeRobots
                )
            )
            stack.append(buildOreRobot)
        }
        
        if state.robots.clayRobots < blueprint.clayForObsidianRobot,
            state.resources.ore >= blueprint.oreForClayRobot {
            let buildClayRobot = State(
                time: harvest.time,
                resources: Resources(
                    ore: harvest.resources.ore - blueprint.oreForClayRobot,
                    clay: harvest.resources.clay,
                    obsidian: harvest.resources.obsidian,
                    geodes: harvest.resources.geodes
                ),
                robots: Robots(
                    oreRobots: harvest.robots.oreRobots,
                    clayRobots: harvest.robots.clayRobots + 1,
                    obsidianRobots: harvest.robots.obsidianRobots,
                    geodeRobots: harvest.robots.geodeRobots
                )
            )
            stack.append(buildClayRobot)
        }
        
        if state.robots.obsidianRobots < blueprint.obsidianForGeodeRobot,
            state.resources.ore >= blueprint.oreForObsidianRobot,
            state.resources.clay >= blueprint.clayForObsidianRobot {
            let buildObsidianRobot = State(
                time: harvest.time,
                resources: Resources(
                    ore: harvest.resources.ore - blueprint.oreForObsidianRobot,
                    clay: harvest.resources.clay - blueprint.clayForObsidianRobot,
                    obsidian: harvest.resources.obsidian,
                    geodes: harvest.resources.geodes
                ),
                robots: Robots(
                    oreRobots: harvest.robots.oreRobots,
                    clayRobots: harvest.robots.clayRobots,
                    obsidianRobots: harvest.robots.obsidianRobots + 1,
                    geodeRobots: harvest.robots.geodeRobots
                )
            )
            stack.append(buildObsidianRobot)
        }
        
        if state.resources.ore >= blueprint.oreForGeodeRobot,
            state.resources.obsidian >= blueprint.obsidianForGeodeRobot {
            let buildGeodeRobot = State(
                time: harvest.time,
                resources: Resources(
                    ore: harvest.resources.ore - blueprint.oreForGeodeRobot,
                    clay: harvest.resources.clay,
                    obsidian: harvest.resources.obsidian - blueprint.obsidianForGeodeRobot,
                    geodes: harvest.resources.geodes
                ),
                robots: Robots(
                    oreRobots: harvest.robots.oreRobots,
                    clayRobots: harvest.robots.clayRobots,
                    obsidianRobots: harvest.robots.obsidianRobots,
                    geodeRobots: harvest.robots.geodeRobots + 1
                )
            )
            stack.append(buildGeodeRobot)
        }
    }
    
    return maxGeodes
}.reduce(1, *)

print(totalQuality)
