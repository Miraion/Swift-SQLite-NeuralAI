//
//  CompetitiveLearningEntity.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class CLEntity : LearningEntity {
    
    // Win/loss stats
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0
    
    var gamesPlayed: Int {
        return wins + losses + ties
    }
    
    // Network for this entity
    var network: NeuralNetwork
    
    // Return the win rate.
    var value: Double {
        if GrandMasterConfig.global.tiesCountAsWins {
            return Double(wins + ties) / Double(gamesPlayed)
        } else {
            return Double(wins) / Double(gamesPlayed)
        }
    }
    
    required init (network: NeuralNetwork) {
        self.network = network
    }
    
    // CLEntities, unlike TLEntities, are ordered by win rate.
    // A higher win rate denotes a better entity hence the
    // value > value instead of value < value.
    static func < (lhs: CLEntity, rhs: CLEntity) -> Bool {
        return lhs.value > rhs.value
    }
    
}
