//
//  LearningThread.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-01.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Cocoa

class LearningThread<LSet: LearningSet> {
    
    var isFinished = false
    let rounds: Int
    var learningSet: LSet
    
    init (_ set: LSet, rounds: Int) {
        self.rounds = rounds
        self.learningSet = set
    }
    
    // Use Grand Central Dispatch to start a training session.
    // Will train for a given number of rounds or until a goal
    // is reached.
    func start (goal: Double, comparison: @escaping (Double, Double) -> Bool) {
        // Reset flags
        isFinished = false
        
        // Queue command via Grand Central Dispatch
        DispatchQueue.global(qos: .default).async {
            if self.learningSet.train(till: goal, or: self.rounds, by: comparison) {
                Flag.global.shouldContinueThreadExecution = false
            }
            self.isFinished = true
        }
    }
    
    // Use Grand Central Dispatch to start a training session.
    // Will train for a given number of rounds.
    func start () {
        isFinished = false
        
        DispatchQueue.global(qos: .default).async {
            self.learningSet.train(rounds: self.rounds)
            self.isFinished = true
        }
    }
    
}
