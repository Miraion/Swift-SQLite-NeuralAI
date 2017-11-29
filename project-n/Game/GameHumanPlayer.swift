//
//  GameHumanPlayer.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Foundation

class GameHumanPlayer : GamePlayer {
    
    var pieceType: GamePiece? = nil
    
    func isValidInput (_ input: String?) -> Bool {
        if let str = input {
            if str.count > 3 {
                return false
            } else {
                return (str[0].asDigit() ?? 4) < 3
                    && str[1] == " "
                    && (str[2].asDigit() ?? 4) < 3
            }
        } else {
            return false
        }
    }
    
    // Assumes str is a valid string according to isValidInput
    func asPoint (_ str: String) -> GamePoint {
        return GamePoint(row: str[0].asDigit()!, column: str[2].asDigit()!)
    }
    
    func getPlay(currentBoard: GameBoard, avaliableSpaces: [GamePoint]) -> GamePoint {
        
        var point = GamePoint(row: -1, column: -1)
        var promptText = "Enter position: <row column> (zero indexed)"
        
        repeat {
            print(promptText)
            print(" > ", terminator: "")
            var input = readLine()
            
            while !isValidInput(input) {
                print("Invalid Input")
                print(" > ", terminator: "")
                input = readLine()
            }
            
            point = asPoint(input!)
            
            promptText = "Point already taken"
            
        } while !avaliableSpaces.contains(point)
        
        return point
    }
    
}
