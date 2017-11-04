//
//  CompetitiveLearningTemplate.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

protocol CLGameTemplate {
    
    func compete (_ entity1: CLEntity, _ entity2: CLEntity) -> CLDualOutcome
    
}
