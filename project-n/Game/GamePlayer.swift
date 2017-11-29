//
//  GamePlayer.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

protocol GamePlayer {
    
    var pieceType: GamePiece? { get set }
    
    func getPlay (currentBoard: GameBoard, avaliableSpaces: [GamePoint]) -> GamePoint
    
}

extension GamePlayer {
    
    // Called before the game loop starts.
    // May be overriden to intialize things.
    func onStart () {}
    
}
