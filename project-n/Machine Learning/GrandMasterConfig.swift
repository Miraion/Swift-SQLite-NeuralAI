//
//  MLMasterConfig.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class GrandMasterConfig {
    
    static var global = GrandMasterConfig()
    
    var smallChangeAmount = 6
    var cloneAmount = 1
    var modifyBest = false
    
    var entitiesPerSet = 10
    
    // CLEntity Settings
    var tiesCountAsWins = true
    
    // CLSet Settings
    var gamesPerEvaluation = 5
    
    // LearningCore Settings
    var pauseOnConvergence = true
    var numThreads = 4
    var threadConvergenceInterval = 20
    var saveInterval = 1
    
}
