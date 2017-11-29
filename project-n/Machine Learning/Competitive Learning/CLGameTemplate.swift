//
//  CompetitiveLearningTemplate.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

protocol CLGameTemplate {
    
    associatedtype Player where Player : CLEntity
    
    init ()
    
    func compete (_ entity1: Player, _ entity2: Player) -> CLDualOutcome
    
}
