//
//  GameAIPlayer.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-05.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class GameAIPlayer : CLEntity, GamePlayer {
    
    var pieceType: GamePiece? = nil
    
    // Network must have 9 inputs and 9 outputs.
    required init (network: NeuralNetwork) {
        super.init(network: network)
    }
    
    // Transforms the gameboard into a linear numerical representation.
    func transform (board: GameBoard) -> [Double] {
        var linearBoardRepresentation = [GamePiece?]()
        for row in board.spaces {
            for space in row {
                linearBoardRepresentation.append(space)
            }
        }
        
        var numericalBoardRepresentation = [Double]()
        for piece in linearBoardRepresentation {
            if let token = piece {
                numericalBoardRepresentation.append(token == piece! ? 1.0 : -1.0)
            } else {
                numericalBoardRepresentation.append(0.0)
            }
        }
        return numericalBoardRepresentation
    }
    
    // Turns a scalar index into a 2D point for a 3 by 3 grid.
    func scalarToPoint (_ i: Int) -> GamePoint {
        let point = GamePoint(row: i / 3, column: i % 3)
        return point
    }
    
    func pointToScalar (_ point: GamePoint) -> Int {
        return (point.row * 3) + point.column
    }
    
    // Assuming that avaliableSpaces is not empty.
    func getPlay(currentBoard: GameBoard, avaliableSpaces: [GamePoint]) -> GamePoint {
        let inputSet = transform(board: currentBoard)
        let ioPair = try! network.solve(for: inputSet)
        var playableIndecies = [Int]()
        for space in avaliableSpaces {
            playableIndecies.append(pointToScalar(space))
        }
        
        // find the best place to play
        var best = (index: -1, value: -1.0)
        for index in playableIndecies {
            if ioPair.out[index] > best.value {
                best.value = ioPair.out[index]
                best.index = index
            }
        }
        
        return scalarToPoint(best.index)
    }
    
}
