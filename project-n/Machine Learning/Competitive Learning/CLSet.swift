//
//  CLSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class CLSet<Game: CLGameTemplate> : LearningSet {
    
    typealias Entity = Game.Player
    
    var stepId: Int = -1
    var entities = [Game.Player]()
    var callingThreadId: Int? = nil
    var lastStats = (best: 0.0, average: 0.0)
    
    var referenceEntity: Entity?
    var game: Game? = nil
    
    required init () {}
    
    convenience init (size: Int, config: NeuralNetworkConfig, reference: Entity) {
        self.init(size, config)
        self.game = Game()
        self.referenceEntity = Entity(network: NeuralNetwork(copy: reference.network))
    }
    
    convenience init (size: Int, seed: NeuralNetwork, reference: Entity) {
        self.init(size, seed)
        self.game = Game()
        self.referenceEntity = Entity(network: NeuralNetwork(copy: reference.network))
    }
    
    // Each entity plays two games against the reference entity.
    func evaluate (_ index: Int) {
        for i in 1..<entities.count {
            // Play with entity being x first
            var result = game!.compete(entities[i], entities[0])
            result.e1.apply(to: entities[i])
            result.e2.apply(to: entities[0])
            
            // Then play with entity being o
            result = game!.compete(entities[0], entities[i])
            result.e2.apply(to: entities[i])
            result.e1.apply(to: entities[0])
            
        }
    }
    
    // Randomize the entity array so that games are between random opponents.
    func beforeEvaluation () {
        entities.shuffle()
    }
    
}
