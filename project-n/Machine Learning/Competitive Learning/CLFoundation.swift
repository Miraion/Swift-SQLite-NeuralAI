//
//  CLFoundation.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

enum CLOutcome {
    case win
    case lose
    case tie
    
    func apply (to entity: CLEntity) {
        switch self {
        case .win: entity.wins += 1
        case .tie: entity.ties += 1
        case .lose: entity.losses += 1
        }
    }
}

typealias CLDualOutcome = (e1: CLOutcome, e2: CLOutcome)
