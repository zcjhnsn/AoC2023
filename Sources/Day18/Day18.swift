//
// Advent of Code 2023 Day 18
//
// https://adventofcode.com/2023/day/18
//

import AoCTools
import RegexBuilder

private struct Plan {
    typealias Trench = (direction: Direction, length: Int)
    let part1: Trench
    let part2: Trench
    
    static let dirMapPart1: [String: Direction] = ["U": .n, "D": .s, "L": .w, "R": .e]
    static let dirMapPart2: [Int: Direction] = [3: .n, 1: .s, 2: .w, 0: .e]
    
    init(_ line: String) {
        let components = line.components(separatedBy: " ")
        self.part1 = (direction: Self.dirMapPart1[components[0]]!, length: Int(components[1])!)
        let color = Int(components[2].substring(2, 6), radix: 16)!
        self.part2 = (direction: Self.dirMapPart2[color & 0xf]!, length: color >> 4)
    }
}

final class Day18: AOCDay {
    
    private let plans: [Plan]
    
    init(input: String) {
        plans = input.lines.map { Plan($0) }
    }

    func part1() -> Int {
        lagoonArea(from: plans, trenches: \.part1)
    }

    func part2() -> Int {
        lagoonArea(from: plans, trenches: \.part2)
    }
    
    private func lagoonArea(from plans: [Plan], trenches keyPath: KeyPath<Plan, Plan.Trench>) -> Int {
        var point = Point.zero
        var points = [point]
        for trench in plans.map({ $0[keyPath: keyPath] }) {
            point = point.moved(to: trench.direction, steps: trench.length)
            points.append(point)
        }
        
        let perimeter = plans.map { $0[keyPath: keyPath].length }.reduce(0, +)
        
        let area = points.adjacentPairs().map { ($0.x * $1.y) - ($0.y * $1.x) }.reduce(0, +)
        
        return area / 2 + perimeter / 2 + 1
    }
}
