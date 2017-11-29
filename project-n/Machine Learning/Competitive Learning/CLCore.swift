//
//  CLCore.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-06.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class CLCore : LearningCore<CLSet<GameTrainer>> {
    
    var referencePlayer: GameAIPlayer
    
    init (config: NeuralNetworkConfig, saveTables: NeuralSaveTables) {
        self.referencePlayer = GameAIPlayer(network: RandomNetwork<HiddenSigmoidNeuron, OutputSigmoidNeuron>(config))
        super.init(saveTables: saveTables)
        
        for i in 0..<GrandMasterConfig.global.numThreads {
            learningSets.append(CLSet<GameTrainer>(size: GrandMasterConfig.global.entitiesPerSet, config: config, reference: referencePlayer))
            learningSets[i].callingThreadId = i
        }
        for set in learningSets {
            threads.append(LearningThread<CLSet>(set, rounds: GrandMasterConfig.global.threadConvergenceInterval))
        }
    }
    
    init (seed: NeuralNetwork, saveTables: NeuralSaveTables) {
        self.referencePlayer = GameAIPlayer(network: NeuralNetwork(copy: seed))
        super.init(saveTables: saveTables)
        
        for i in 0..<GrandMasterConfig.global.numThreads {
            learningSets.append(CLSet<GameTrainer>(size: GrandMasterConfig.global.entitiesPerSet, seed: seed, reference: referencePlayer))
            learningSets[i].callingThreadId = i
        }
        for set in learningSets {
            threads.append(LearningThread<CLSet>(set, rounds: GrandMasterConfig.global.threadConvergenceInterval))
        }
    }
    
    override func threadComparison(lhs: Double, rhs: Double) -> Bool {
        return lhs > rhs
    }
    
    override func threadStatsComparison(_ lhs: (Int, Double), _ rhs: (Int, Double)) -> Bool {
        return lhs.1 > rhs.1
    }
    
    // Set the network in the referecePlayer to be a clone of the best network.
    override func onConvergence(_ bestEntity: GameAIPlayer) {
        referencePlayer.network = NeuralNetwork(copy: bestEntity.network)
        for thread in threads {
            for entity in thread.learningSet.entities {
                entity.reset()
            }
        }
    }
    
}
