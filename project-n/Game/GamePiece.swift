//
//  GamePiece.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

enum GamePiece {
    case x
    case o
    
    var toString: String {
        switch self {
        case .x: return "X"
        case .o: return "O"
        }
    }
}
