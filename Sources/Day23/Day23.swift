//
// Advent of Code 2023 Day 23
//
// https://adventofcode.com/2023/day/23
//

import AoCTools
// paths (.), forest (#), and steep slopes (^, >, v, and <).
private enum Tile {
    case path
    case forest
    case slope(Dir)
    
    static func parse(_ ch: Character) -> Self {
        switch ch {
        case ".": return .path
        case "#": return .forest
        case "^": return .slope(.up)
        case "v": return .slope(.down)
        case ">": return .slope(.right)
        case "<": return .slope(.left)
        default: fatalError("Unknown tile: \(ch)")
        }
    }
    
    var isEmpty: Bool {
        guard case .path = self else {
            return false
        }
        return true
    }
}

final class Day23: AOCDay {
    private let map: [[Tile]]
    
    init(input: String) {
        map = input
                .lines
                .map { $0.map(Tile.parse) }
    }
    
    func part1() -> Int {
        let maxRouteLen = solve(map)
        return maxRouteLen
    }
    
    func part2() -> Int {        
        let map = map
            .map { row in row.map { tile in
                switch tile {
                case .path, .forest: return tile
                case .slope(_): return .path
                }
            }}
        let maxRouteLen = solve(map)
        return maxRouteLen

    }
    
    private func solve(_ map: [[Tile]]) -> Int {
        let (map, start, target) = reducedMap(map: map)
        
        func dfs(_ pos: Pos, _ len: Int, _ visited: inout Set<Pos>) -> Int? {
            guard pos != target else { return len }
            guard visited.contains(pos) == false else { return nil }
            var maxLen: Int?
            visited.insert(pos)
            for (nextPos, dist) in map[pos]! {
                if let nextLen = dfs(nextPos, len + dist, &visited) {
                    maxLen = max(nextLen, maxLen ?? 0)
                }
            }
            visited.remove(pos)
            return maxLen
        }
        var visited = Set<Pos>()
        return dfs(start, 0, &visited)!
    }
    
    private func reducedMap(map: [[Tile]]) -> ([Pos: [Pos: Int]], start: Pos, target: Pos) {
        var result = [Pos: [Pos: Int]]()
        
        let start = Pos(x: map.first!.firstIndex(where: { $0.isEmpty })!, y: 0)
        let target = Pos(x: map.last!.firstIndex(where: { $0.isEmpty })!, y: map.count - 1)
        
        func nbs(_ pos: Pos) -> [Pos] {
            Dir.allCases.map { pos + $0.delta }.filter { nPos in
                switch map.at(nPos) {
                case .path, .slope(_): return true
                default: return false
                }
            }
        }
        
        let junctions = Set(
            map.enumerated()
                .flatMap { y, row in
                    row.enumerated().compactMap { (x, tile) -> Pos? in
                        guard tile.isEmpty else { return nil }
                        let pos = Pos(x: x, y: y)
                        return nbs(pos).count >= 3 ? pos : nil
                    }
                }
            + [start, target]
        )
        
        for pos in junctions {
            for nStart in nbs(pos) {
                var len = 1
                var isCorrect = true
                var (prev, cur) = (pos, nStart)
                while junctions.contains(cur) == false {
                    if case .slope(let dir) = map.at(cur) {
                        if cur + dir.delta == prev {
                            isCorrect = false
                            break
                        }
                        len += 1
                        (prev, cur) = (cur, cur + dir.delta)
                        continue
                    }
                    len += 1
                    (prev, cur) = (cur, nbs(cur).first(where: { $0 != prev })!)
                }
                if isCorrect {
                    result[pos, default: [:]][cur] = len
                }
            }
        }
        return (result, start, target)
    }
 
}

//
//  Day23.swift
//  AdventOfCode2023
//
//  Created by Nikolay Volosatov on 23/12/2023.
//

import Foundation


public enum Dir: CaseIterable {
    case up
    case down
    case left
    case right
}

public extension Dir {
    var delta: Pos {
        switch self {
        case .up:       return .init(x: 0, y: -1)
        case .down:     return .init(x: 0, y: 1)
        case .left:     return .init(x: -1, y: 0)
        case .right:    return .init(x: 1, y: 0)
        }
    }
    
    var rev: Dir {
        switch self {
        case .left: return .right
        case .right: return .left
        case .up: return .down
        case .down: return .up
        }
    }
    
    var rotationDirs: [Dir] {
        switch self {
        case .up, .down: return [.left, .right]
        case .left, .right: return [.up, .down]
        }
    }
}

//
//  Pos.swift
//  
//
//  Created by Nikolay Volosatov on 15/12/2022.
//

public struct Pos: Hashable, CustomStringConvertible {
    public let x: Int
    public let y: Int
    
    public var description: String { "(\(x),\(y))" }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public func +(lhs: Pos, rhs: Pos) -> Pos {
    .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func -(lhs: Pos, rhs: Pos) -> Pos {
    .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func *(lhs: Pos, rhs: Int) -> Pos {
    .init(x: lhs.x * rhs, y: lhs.y * rhs)
}

public extension Pos {
    func manhDist(_ other: Pos) -> Int {
        return abs(other.x - x) + abs(other.y - y)
    }
    
    func wrap(w: Int, h: Int) -> Pos {
        let x = x < 0
        ? (w - ((-x) % w)) % w
        : (x % w)
        let y = y < 0
        ? (h - ((-y) % h)) % h
        : (y % h)
        return .init(x: x, y: y)
    }
}

public extension Array {
    func at<T>(_ pos: Pos) -> Optional<T> where Element == Array<T> {
        guard 0 <= pos.y && pos.y < count else { return nil }
        let row = self[pos.y]
        guard 0 <= pos.x && pos.x < row.count else { return nil }
        return row[pos.x]
    }
}
