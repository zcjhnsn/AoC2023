//
// Advent of Code 2023 Day 18 Tests
//

import XCTest
@testable import AdventOfCode

final class Day18Tests: XCTestCase {
    let testInput = """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
"""

    func testDay18_part1() throws {
        let day = Day18(input: testInput) 
        XCTAssertEqual(day.part1(), 62)
    }

    func testDay18_part1_solution() throws {
        let day = Day18(input: Day18.input) 
        XCTAssertEqual(day.part1(), 36807)
    }

    func testDay18_part2() throws {
        let day = Day18(input: testInput)
        XCTAssertEqual(day.part2(), 952408144115)
    }

    func testDay18_part2_solution() throws {
        let day = Day18(input: Day18.input) 
        XCTAssertEqual(day.part2(), 48797603984357)
    }
}
