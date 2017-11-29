//
//  GameController.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

// The game controller for a game of tic-tac-toe
class GameController {
    
    var board = GameBoard()
    
    var xPlayer: (player: GamePlayer, id: Int)? = nil
    var oPlayer: (player: GamePlayer, id: Int)? = nil
    
    let useDisplay: Bool
    
    init (display: Bool) {
        self.useDisplay = display
    }
    
    func allX (_ arr: [GamePiece?]) -> Bool {
        for piece in arr {
            if piece != GamePiece.x {
                return false
            }
        }
        return true
    }
    
    func allO (_ arr: [GamePiece?]) -> Bool {
        for piece in arr {
            if piece != GamePiece.o {
                return false
            }
        }
        return true
    }
    
    func xWins () -> CLDualOutcome {
        if xPlayer!.id == 1 {
            return (.win, .lose)
        } else {
            return (.lose, .win)
        }
    }
    
    func oWins () -> CLDualOutcome {
        if oPlayer!.id == 1 {
            return (.win, .lose)
        } else {
            return (.lose, .win)
        }
    }
    
    func winner () -> CLDualOutcome? {
        // Check rows and columns for 3 of a kind.
        for i in 0..<3 {
            if allX(board.column(i)) {
                return xWins()
            } else if allO(board.column(i)) {
                return oWins()
            } else if allX(board.row(i)) {
                return xWins()
            } else if allO(board.row(i)) {
                return oWins()
            }
        }
        
        // Check diagonals for 3 of a kind.
        if allX(board.diagonalLeft()) || allX(board.diagonalRight()) {
            return xWins()
        } else if allO(board.diagonalLeft()) || allO(board.diagonalRight()) {
            return oWins()
        }
        
        // No 3 of a kinds.
        // Check if there are no more spaces left, if so then tie.
        if board.avaliableSpaces().count == 0 {
            return (.tie, .tie)
        }
        
        // If none of these, then game is not finished so no winner.
        return nil
    }
    
    func play (_ p1: GamePlayer, _ p2: GamePlayer) -> CLDualOutcome {
        
        xPlayer = (p1, 1)
        xPlayer!.player.pieceType = .x
        oPlayer = (p2, 2)
        oPlayer!.player.pieceType = .o
        
        xPlayer!.player.onStart()
        oPlayer!.player.onStart()
        
        board.reset()
        
        // Main game loop.
        repeat {
            
            if winner() != nil {
                break
            }
            
            if useDisplay {
                GameDisplay.displayGameBoard(board)
            }
            let xPlay = xPlayer!.player.getPlay(currentBoard: board, avaliableSpaces: board.avaliableSpaces())
            board[xPlay] = .x
            
            if winner() != nil {
                break
            }
            
            if useDisplay {
                GameDisplay.displayGameBoard(board)
            }
            let oPlay = oPlayer!.player.getPlay(currentBoard: board, avaliableSpaces: board.avaliableSpaces())
            board[oPlay] = .o
            
        } while winner() == nil
        
        let win = winner()!
        if useDisplay {
            if win.e1 == .win {
                print("Player 1 [\(xPlayer!.id == 1 ? "X" : "O")] wins")
            } else if win.e2 == .win {
                print("Player 2 [\(xPlayer!.id == 2 ? "X" : "O")] wins")
            } else {
                print("Tie")
            }
        }
        
        return win
    }
}
