//
//  GameDisplay.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class GameDisplay {
    
    // A simple visual representation of the game board.
    static func displayGameBoard (_ board: GameBoard) {
        for row in board.spaces {
            for column in row {
                
                if let piece = column {
                    switch piece {
                    case .x: print("X", terminator: "")
                    case .o: print("O", terminator: "")
                    }
                } else {
                    print("-", terminator: "")
                }
                
                print(" ", terminator: "")
            }
            print()
        }
    }
    
}
