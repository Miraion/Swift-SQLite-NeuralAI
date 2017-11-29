//
//  GameBoard.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class GameBoard {
    
    var spaces: [[GamePiece?]]
    
    init () {
        spaces = [[GamePiece?]]()
        
        for i in 0..<3 {
            spaces.append([GamePiece?]())
            for _ in 1...3 {
                spaces[i].append(nil)
            }
        }
    }
    
    subscript (i: Int, j: Int) -> GamePiece? {
        get {
            return spaces[i][j]
        }
        set {
            spaces[i][j] = newValue
        }
    }
    
    subscript (point: GamePoint) -> GamePiece? {
        get {
            return spaces[point.row][point.column]
        }
        set {
            spaces[point.row][point.column] = newValue
        }
    }
    
    func avaliableSpaces () -> [GamePoint] {
        var arr = [GamePoint]()
        for i in 0..<spaces.count {
            for j in 0..<spaces[i].count {
                if self[i, j] == nil {
                    arr.append(GamePoint(row: i, column: j))
                }
            }
        }
        return arr
    }
    
    func column (_ j: Int) -> [GamePiece?] {
        var col = [GamePiece?]()
        for i in 0..<spaces.count {
            col.append(spaces[i][j])
        }
        return col
    }
    
    func row (_ i: Int) -> [GamePiece?] {
        return spaces[i]
    }
    
    func diagonalLeft () -> [GamePiece?] {
        return [self[0,0], self[1,1], self[2,2]]
    }
    
    func diagonalRight () -> [GamePiece?] {
        return [self[0,2], self[1,1], self[2,0]]
    }
    
    func allSpacesFilled () -> Bool {
        for row in spaces {
            for elem in row {
                if elem == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func reset () {
        for i in 0..<spaces.count {
            for j in 0..<spaces[i].count {
                spaces[i][j] = nil
            }
        }
    }
    
}
