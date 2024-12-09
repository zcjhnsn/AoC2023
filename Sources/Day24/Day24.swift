//
// Advent of Code 2023 Day 24
//
// https://adventofcode.com/2023/day/24
//

import AoCTools


private struct Stone {
    typealias P3 = (x: Double, y: Double, z: Double)
    
    let p: P3
    let v: P3
    
    // 19, 13, 30 @ -2,  1, -2
    init(_ string: String) {
        let parts = string.components(separatedBy: "@")
        let pos = parts[0].allInts().map { Double($0) }
        let vel = parts[1].allInts().map { Double($0) }
        p = (pos[0], pos[1], pos[2])
        v = (vel[0], vel[1], vel[2])
    }
}

final class Day24: AOCDay {
    private let stones: [Stone]
    private let range: ClosedRange<Double>
    
    convenience init(input: String) {
        self.init(input: input, range: 200000000000000.0 ... 400000000000000.0)
    }
    
    init(input: String, range: ClosedRange<Double>) {
        stones = input.lines.map { Stone($0) }
        self.range = range
    }
    
    func part1() -> Int {
        // https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
        var total = 0
        for pair in stones.combinations(of: 2) {
            let s1 = pair[0]
            let s2 = pair[1]
            let (slope1, intercept1) = slopeIntercept(for: s1)
            let (slope2, intercept2) = slopeIntercept(for: s2)
            
            if slope1 == slope2 {
                continue // lines are parallel or identical
            }
            
            let xCross = (intercept2 - intercept1) / (slope1 - slope2)
            let yCross = slope1 * xCross + intercept1
            if range ~= xCross && range ~= yCross {
                let tCross1 = (xCross - s1.p.x) / s1.v.x
                let tCross2 = (xCross - s2.p.x) / s2.v.x
                if tCross1 >= 0 && tCross2 >= 0 {
                    total += 1
                }
            }
        }
        
        return total
    }
    
    private func slopeIntercept(for stone: Stone) -> (slope: Double, intercept: Double) {
        let slope = stone.v.y / stone.v.x
        let intercept = stone.p.y - slope * stone.p.x
        return (slope, intercept)
    }
    
    func part2() -> Int {
        let s1 = stones[0]
        let s2 = stones[1]
        let s3 = stones[2]
        
        let string = """

Paste this into https://sagecell.sagemath.org/

var('x y z vx vy vz t1 t2 t3 result')
eq1 = x + (vx * t1) == \(Int(s1.p.x)) + (\(Int(s1.v.x)) * t1)
eq2 = y + (vy * t1) == \(Int(s1.p.y)) + (\(Int(s1.v.y)) * t1)
eq3 = z + (vz * t1) == \(Int(s1.p.z)) + (\(Int(s1.v.z)) * t1)
eq4 = x + (vx * t2) == \(Int(s2.p.x)) + (\(Int(s2.v.x)) * t2)
eq5 = y + (vy * t2) == \(Int(s2.p.y)) + (\(Int(s2.v.y)) * t2)
eq6 = z + (vz * t2) == \(Int(s2.p.z)) + (\(Int(s2.v.z)) * t2)
eq7 = x + (vx * t3) == \(Int(s3.p.x)) + (\(Int(s3.v.x)) * t3)
eq8 = y + (vy * t3) == \(Int(s3.p.y)) + (\(Int(s3.v.y)) * t3)
eq9 = z + (vz * t3) == \(Int(s3.p.z)) + (\(Int(s3.v.z)) * t3)
eq10 = result == x + y + z
print(solve([eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8,eq9,eq10],x,y,z,vx,vy,vz,t1,t2,t3,result))

"""
        
        print(string)
        
        return 0
    }
}
