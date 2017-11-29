//
//  LearningSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Foundation

protocol LearningSet {
    
    // Since each differeny type of learning system is going to have its own
    // coresponding entity, we use an associated type to denote that entity
    // in this generic protocol.
    associatedtype Entity where Entity: LearningEntity
    
    
    // The set of entities that are apart of this learning set.
    var entities: [Entity] { get set }
    
    
    // Id of the thread that this set it running from.
    // Used for printing to stdout. Does not have any computational significance.
    var callingThreadId: Int? { get }
    
    
    // Incremented every time step() is called.
    // Also used only for printing.
    //
    // Should be initalized to -1.
    var stepId: Int { get set }
    
    
    // Used for printing.
    var lastStats: (best: Double, average: Double) { get set }
    
    
    // Default constructor is required for other constructors to be declared in
    // the extension. This constructor should just initalize all member variables
    // and not add any entites or anything like that.
    init ()
    
    
    // Should evaluate a given learning entity and store the results in said entity.
    // This method is called for each entity in the set every round of training.
    //
    // Parameter index is the index of the element to be evaluated in entities array.
    func evaluate (_ index: Int)
    
    
    // Called before evaluating the entities.
    mutating func beforeEvaluation ()
    
}

extension LearningSet {
    
    // Populates the learning set with random networks.
    init (_ size: Int, _ config: NeuralNetworkConfig) {
        self.init()
        
        for _ in 0..<size {
            entities.append(Entity(network: RandomNetwork<HiddenSigmoidNeuron, OutputSigmoidNeuron>(config)))
        }
    }
    
    
    // Populates the learing set with slight modifications of a seed network.
    init (_ size: Int, _ seed: NeuralNetwork) {
        self.init()
        
        entities.append(Entity(network: NeuralNetwork(copy: seed)))
        for _ in 1..<size {
            let net = NeuralNetwork(copy: seed)
            net.tweakWeight(chance: 50)
            net.tweakBias(chance: 20)
            entities.append(Entity(network: net))
        }
    }
    
    
    // Sorts the entities array.
    // Since the associated type exends Comparable, specific comparison for sorting
    // is not required. Though, if needed, this method may be overriden.
    mutating func sortEntities () {
        entities.sort()
    }
    
    
    // Applies random mutation to all networks other than the best preforming one.
    // Networks that preform better are modified less than one that preform worse.
    // The worst 10 networks are replaced with slight modifications on the best
    // network while the other worst ones are randomized.
    mutating func mutate () {
        let startIndex: Int
        if GrandMasterConfig.global.modifyBest {
            startIndex = 0
        } else {
            startIndex = 1
        }
        
        for i in startIndex..<entities.count {
            if i > (entities.count - GrandMasterConfig.global.cloneAmount) {
                entities[i].network = NeuralNetwork(copy: entities[0].network)
                entities[i].network.tweakWeight(chance: 20, range: 0.1)
                entities[i].network.tweakBias(chance: 10, range: 0.1)
            } else if i < GrandMasterConfig.global.smallChangeAmount {
                entities[i].network.tweakWeight(chance: 60, range: 0.3)
                entities[i].network.tweakBias(chance: 40, range: 0.2)
            } else {
                entities[i].network.randomizeWeight(chance: 100)
                entities[i].network.randomizeBias(chance: 100)
            }
        }
    }
    
    
    // Does nothing by default.
    mutating func beforeEvaluation () {}
    
    
    // The method that runs though a single training iteration.
    // Returns the value of the best preforming network. This is used in the method
    // train(till goal:, or rounds:) to determin if the traing has reached its goal.
    @discardableResult
    mutating func step () -> Double {
        stepId += 1
        
        // Don't mutate the entites until they have been evaluated at least once.
        if stepId != 0 {
            mutate()
        }
        
        // Evaluate each network by calling the abstract evaluate(_ entity:) method.
        for i in 0..<entities.count {
            evaluate(i)
        }
        
        // Sort the entities after evaluating them.
        sortEntities()
        
        // Send a progress report to display
        var average = 0.0
        for entity in entities {
            average += entity.value
        }
        average = average / Double(entities.count)
        
        let best = entities[0].value
        
        let progress = ProgressDataSet(threadId: callingThreadId ?? 0, roundNum: stepId, best: best, average: average, changeBest: best - lastStats.best, changeAverage: average - lastStats.average)
        Display.instance.addData(progress)
        
        lastStats.best = best
        lastStats.average = average
        
        return best
    }
    
    
    // Runs through a given number of rounds.
    mutating func train (rounds: Int) {
        for _ in 1...rounds {
            step()
            
            // Stop training if global flag is triggered
            if !Flag.global.shouldContinueThreadExecution {
                break
            }
        }
    }
    
    
    // Trains this set until a given goal is reached or a given
    // number of rounds has passed.
    //
    // Returns true if training ended because goal was reached,
    // otherwise false.
    @discardableResult
    mutating func train (till goal: Double, or rounds: Int, by comparison: (Double, Double) -> Bool) -> Bool {
        for _ in 1...rounds {
            if comparison(step(), goal) {
                return true
            }
            
            // Stop training if global flag is triggered
            if !Flag.global.shouldContinueThreadExecution {
                break
            }
        }
        return false
    }
    
}
