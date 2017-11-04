//
//  Connection.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class Connection {
    
    let innovationValue: Int
    
    var weight: Double
    
    var targetNeuron: Neuron
    
    init (innov: Int, weight: Double, target: Neuron) {
        self.innovationValue = innov
        self.weight = weight
        self.targetNeuron = target
    }
    
    func feedForward () -> Double {
        return targetNeuron.calculate() * weight
    }
    
}
