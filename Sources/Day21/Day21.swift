//
// Advent of Code 2023 Day 21
//
// https://adventofcode.com/2023/day/21
//

import AoCTools
import Collections
import Foundation

private struct Grid {
    private let grid: [[Character]]
    let start: Point
    
    init(_ string: String) {
        var grid = string.lines.map { $0.map { $0 } }
        let startY = grid.firstIndex { $0.contains("S") }!
        let startX = grid[startY].firstIndex { $0 == "S" }!
        grid[startY][startX] = "."
        self.grid = grid
        self.start = Point(startX, startY)
    }
    
    subscript(index: Point) -> Character {
        let x = map(index.x, grid[0].count)
        let y = map(index.y, grid.count)
        return grid[y][x]
    }
    
    var maxX: Int {
        grid[0].count
    }
    
    var maxY: Int {
        grid.count
    }
    
    private func map(_ value: Int, _ max: Int) -> Int {
        let mod = value % max
        return mod < 0 ? max + mod : mod
    }
}

final class Day21: AOCDay {
    private let grid: Grid
    let maxSteps: Int
    
    convenience init(input: String) {
        self.init(input: input, maxSteps: 64)
    }
    
    init(input: String, maxSteps: Int) {
        self.grid = Grid(input)
        self.maxSteps = maxSteps
    }

    func part1() -> Int {
        fill(start: grid.start, startingSteps: maxSteps) 
    }

    // we're going to make a lot of assumptions about our data: 
    // - length is odd
    // - starting row and column always contain no rocks
    func part2() -> Int {
        // assume grid is square
        assert(grid.maxX == grid.maxY)
        
        let size = grid.maxX
        // assume we start in the middle of grid
        assert(grid.start.x == grid.start.y && grid.start.x == size / 2)
        // assume maxSteps is a multiple of grid size over 2 because maxSteps mod grid size is 202300 and that can't be coincidence
//        assert(maxSteps % size == size / 2)
        
        // get how many grids wide our maxSteps is
        let gridWidth = maxSteps / size - 1
        
        let odd = gridWidth / 2 * 2 + 1
        let even = (gridWidth + 1) / 2 * 2
        let oddGrids = Int(pow(Double(odd), 2))
        let evenGrids = Int(pow(Double(even), 2))
                       
        let odd_points = fill(start: grid.start, startingSteps: size * 2 + 1)
        let even_points = fill(start: grid.start, startingSteps: size * 2)
                       
        let corner_t = fill(start: Point(grid.start.x, size - 1), startingSteps: size - 1)
        let corner_r = fill(start: Point(0, grid.start.y), startingSteps: size - 1)
        let corner_b = fill(start: Point(grid.start.x, 0), startingSteps: size - 1)
        var corner_l = fill(start: Point(size - 1, grid.start.y), startingSteps: size - 1)
                       
        var small_tr = fill(start: Point(0, size - 1), startingSteps: Int(floor(Double(size / 2)) - 1))
        var small_tl = fill(start: Point(size - 1, size - 1), startingSteps: Int(floor(Double(size / 2)) - 1))
        var small_br = fill(start: Point(0, 0), startingSteps: Int(floor(Double(size / 2)) - 1))
        var small_bl = fill(start: Point(size - 1, 0), startingSteps: Int(floor(Double(size / 2)) - 1))
                                                                                       
        var large_tr = fill(start: Point(0, size - 1), startingSteps: Int(floor(Double(size * 3 / 2)) - 1))
        var large_tl = fill(start: Point(size - 1, size - 1), startingSteps: Int(floor(Double(size * 3 / 2)) - 1))
        var large_br = fill(start: Point(0, 0), startingSteps: Int(floor(Double(size * 3 / 2)) - 1))
        var large_bl = fill(start: Point(size - 1, 0), startingSteps: Int(floor(Double(size * 3 / 2)) - 1))
        
        let ans = oddGrids * odd_points +
        evenGrids * even_points +
        corner_t + corner_r + corner_b + corner_l +
        (gridWidth + 1) * (small_tr + small_tl + small_br + small_bl) +
        gridWidth * (large_tr + large_tl + large_br + large_bl)
        return ans
    }
    
    private func fill(start: Point, startingSteps: Int) -> Int {
        var ans = Set<Point>()
        var seen = [start: true]
        var steps = startingSteps
        var queue = Deque([(point: start, steps: steps)])
        
        while !queue.isEmpty {
            let location = queue.popFirst()!
            
            if location.steps % 2 == 0 {
                ans.insert(location.point)
            } 
            
            if location.steps == 0 {
                continue
            }
            
            for neighbor in location.point.neighbors() {
                if neighbor.y < 0 || neighbor.y >= grid.maxY || neighbor.x < 0 || neighbor.x >= grid.maxX || grid[neighbor] == "#" || seen[neighbor] != nil {
                    continue
                }
                
                seen[neighbor] = true
                queue.append((point: neighbor, steps: location.steps - 1))
            }
        }
        
        return ans.count
    }
}
