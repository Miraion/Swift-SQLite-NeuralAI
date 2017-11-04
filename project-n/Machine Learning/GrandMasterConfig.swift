//
//  MLMasterConfig.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class GrandMasterConfig {
    
    static var global = GrandMasterConfig()
    
    var smallChangeAmount = 80
    var cloneAmount = 10
    
    var entitiesPerSet = 100
    
    // CLEntity Settings
    var tiesCountAsWins = true
    
    // CLSet Settings
    var gamesPerEvaluation = 10
    
    // LearningCore Settings
    var pauseOnConvergence = true
    var numThreads = 4
    var threadConvergenceInterval = 200
    var saveInterval = 5
    
}
