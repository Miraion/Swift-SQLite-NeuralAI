//
//  CLSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class CLSet : LearningSet {
    
    typealias Entity = CLEntity
    
    var stepId: Int = -1
    var entities = [CLEntity]()
    var callingThreadId: Int? = nil
    var lastStats = (best: 0.0, average: 0.0)
    
    var game: CLGameTemplate? = nil
    
    required init () {}
    
    convenience init (size: Int, config: NeuralNetworkConfig, game: CLGameTemplate) {
        self.init(size: size, config: config)
        self.game = game
    }
    
    convenience init (size: Int, seed: NeuralNetwork, game: CLGameTemplate) {
        self.init(size: size, seed: seed)
        self.game = game
    }
    
    // Each entity will play against a set number of random opponents.
    func evaluate (_ index: Int) {
        for i in 0..<entities.count {
            for j in 1...GrandMasterConfig.global.gamesPerEvaluation {
                let e1 = entities[i]
                let e2 = entities.circularStride(start: i, distance: j)
                let result = game!.compete(e1, e2)
                
                result.e1.apply(to: e1)
                result.e2.apply(to: e2)
            }
        }
    }
    
    // Randomize the entity array so that games are between random opponents.
    func beforeEvaluation () {
        entities.shuffle()
    }
    
}
