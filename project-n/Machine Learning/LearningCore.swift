//
//  LearningCore.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

typealias NeuralSaveTables = (node: SQLiteDatabase.SQLiteTable, conn: SQLiteDatabase.SQLiteTable)

class LearningCore<LSet: LearningSet> {
    
    let saveTables: NeuralSaveTables
    
    var learningSets = [LSet]()
    var threads = [LearningThread<LSet>]()
    
    init (saveTables: NeuralSaveTables) {
        self.saveTables = saveTables
    }
    
    // Returns true if all the threads are finished executing
    func allThreadsFinished () -> Bool {
        var finished = true
        for thread in threads {
            finished = finished && thread.isFinished
        }
        return finished
    }
    
    // Returns whether training should terminate or not
    func onPauseCommandInterface (_ bestNetwork: NeuralNetwork) -> Bool {
        var command: String? = ""
        print("Pause Commands [save, continue, quit]")
        repeat {
            print(" > ", terminator: "")
            command = readLine()
            
            if command == "save" {
                print("Saving...")
                bestNetwork.save(nodeTable: saveTables.node, connTable: saveTables.conn)
            }
            
            if command == "quit" {
                print("Terminating training session...")
                return true
            }
            
        } while command != "continue"
        return false
    }
    
    @discardableResult
    func train (till goal: Double? = nil) -> NeuralNetwork {
        
        var bestDifferenceValue = 0.0
        var bestNetwork: LSet.Entity? = nil
        
        var convergenceCount = 0
        
        Display.instance.setUp(numThreads: threads.count)
        Flag.global.shouldContinueThreadExecution = true
        
        repeat {
            
            for thread in threads {
                if let g = goal {
                    thread.start(goal: g)
                } else {
                    thread.start()
                }
            }
            
            // Wait till all threads are finished executing
            let displayUpdateInterval = 100
            var count = 0
            while !allThreadsFinished() {
                
                // Display progress reports while training
                if count > displayUpdateInterval {
                    if let report = Display.instance.getNextDataSet() {
                        print(report)
                    }
                    count = 0
                } else {
                    count += 1
                }
            }
            
            // -- Thread Convergence -- //
            
            var bestNetworks = [(threadId: Int, network: LSet.Entity)]()
            for i in 0..<threads.count {
                bestNetworks.append((threadId: i, network: threads[i].learningSet.entities[0]))
            }
            
            // Extract the difference values for the best network in each thread
            var threadStats = [(id: Int, value: Double)]()
            for i in 0..<threads.count {
                threadStats.append((id: i, value: threads[i].learningSet.entities[0].value))
            }
            
            threadStats.sort(by: { $0.value < $1.value })
            let bestThreadId = threadStats.first!.id
            let worstThreadId = threadStats.last!.id
            
            bestNetwork = threads[bestThreadId].learningSet.entities[0]
            bestDifferenceValue = bestNetwork!.value
            
            // Transplant clone of best network into worst thread
            let bestClone = NeuralNetwork(copy: bestNetwork!.network)
            // Tweak it slightly so that its not an exact copy
            bestClone.tweakWeight(chance: 10, range: 0.1)
            // Overrite the best entity with the clone
            threads[worstThreadId].learningSet.entities[0] = LSet.Entity(network: bestClone)
            
            // Save the best network if the interval is up
            if convergenceCount % GrandMasterConfig.global.saveInterval == 0 {
                bestNetwork!.network.save(nodeTable: saveTables.node, connTable: saveTables.conn)
            }
            
            print("-- Thread Convergence \(convergenceCount) --")
            print()
            if let report = Display.instance.getNextDataSet(force: true) {
                print(report)
            }
            if let g = goal {
                print("Target: \(g)")
            }
            print("Best  : \(bestDifferenceValue)")
            print()
            
            if GrandMasterConfig.global.pauseOnConvergence && (Flag.global.shouldContinueThreadExecution) {
                print("Paused...")
                // If command to quit is entered traing will stop
                if onPauseCommandInterface(bestNetwork!.network) {
                    return bestNetwork!.network
                }
            }
            
            convergenceCount += 1
            
        } while Flag.global.shouldContinueThreadExecution
        
        return bestNetwork!.network
    }
    
}


extension LearningCore where LSet == TLSet {
    
    convenience init (config: NeuralNetworkConfig, target: NeuralIOSet, saveTables: NeuralSaveTables) {
        self.init(saveTables: saveTables)
        
        for i in 0..<GrandMasterConfig.global.numThreads {
            learningSets.append(TLSet(size: GrandMasterConfig.global.entitiesPerSet, config: config, target: target))
            learningSets[i].callingThreadId = i
        }
        for set in learningSets {
            threads.append(LearningThread<TLSet>(set, rounds: GrandMasterConfig.global.threadConvergenceInterval))
        }
    }
    
}


extension LearningCore where LSet == CLSet {
    
    convenience init (config: NeuralNetworkConfig, game: CLGameTemplate, saveTables: NeuralSaveTables) {
        self.init(saveTables: saveTables)
        
        for i in 0..<GrandMasterConfig.global.numThreads {
            learningSets.append(CLSet(size: GrandMasterConfig.global.entitiesPerSet, config: config, game: game))
            learningSets[i].callingThreadId = i
        }
        for set in learningSets {
            threads.append(LearningThread<CLSet>(set, rounds: GrandMasterConfig.global.threadConvergenceInterval))
        }
    }
    
}



