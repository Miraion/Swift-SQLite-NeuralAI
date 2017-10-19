//
//  HiddenNeuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

//  Identifier type for hidden neurons.
protocol HiddenNeuron : Neuron {
    
    var storedValue: Double? { get set }
    
    // Hidden neurons must have connections to other neurons.
    var connections: [Connection] { get set }
    
    // Hidden neurons must have an activation function.
    func activationFunction (_ inValue: Double) -> Double
    
}

extension HiddenNeuron {
    
    // Definition for Neuron.calculate method.
    mutating func calculate () -> Double {
        if storedValue != nil {
            return storedValue!
        } else {
            var sum: Double = 0
            for conn in connections {
                sum += conn.feedForward()
            }
            storedValue = activationFunction(sum)
            return storedValue!
        }
    }
    
    // Hidden neurons may have connections between them,
    //  this method adds such connections.
    mutating func addConnection (to target: Neuron, weight: Double, innov: Int) {
        connections.append(Connection(innov: innov, weight: weight, target: target))
    }
    
}
