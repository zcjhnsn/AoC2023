//
// Advent of Code 2023 Day 16 Tests
//

import XCTest
@testable import AdventOfCode

final class Day16Tests: XCTestCase {
    let testInput = #"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
"""#

    func testDay16_part1() throws {
        let day = Day16(input: testInput) 
        XCTAssertEqual(day.part1(), 46)
    }

    func testDay16_part1_solution() throws {
        let day = Day16(input: Day16.input) 
        XCTAssertEqual(day.part1(), 7307)
    }

    func testDay16_part2() throws {
        let day = Day16(input: testInput)
        XCTAssertEqual(day.part2(), 51)
    }

    func testDay16_part2_solution() throws {
        let day = Day16(input: Day16.input) 
        XCTAssertEqual(day.part2(), 7635)
    }
}
