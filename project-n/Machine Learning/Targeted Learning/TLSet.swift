//
//  NetworkSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-31.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class TLSet : LearningSet {
    
    typealias Entity = TLEntity
    
    var stepId: Int = -1
    var entities = [TLEntity]()
    var callingThreadId: Int? = nil
    var lastStats = (best: 0.0, average: 0.0)
    
    var target: NeuralIOSet? = nil
    
    required init () {}
    
    convenience init (size: Int, config: NeuralNetworkConfig, target: NeuralIOSet) {
        self.init(size: size, config: config)
        self.target = target
    }
    
    convenience init (size: Int, seed: NeuralNetwork, target: NeuralIOSet) {
        self.init(size: size, seed: seed)
        self.target = target
    }
    
    func evaluate (_ index: Int) {
        entities[index].differenceValue =
            try! NeuralIOSet(solve: entities[index].network, inputs: target!.inputs)!.difference(from: target!)
    }
    
}
