//
//  GamePoint.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

struct GamePoint : Equatable {
    
    let row: Int
    let column: Int
    
    static func == (lhs: GamePoint, rhs: GamePoint) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
}
