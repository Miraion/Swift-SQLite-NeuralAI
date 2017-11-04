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
    
    var bias: Double { get set }
    
    // Hidden neurons must have connections to other neurons.
    var connections: [Connection] { get set }
    
    init (_ other: HiddenNeuron)
    
    // Hidden neurons must have an activation function.
    func activationFunction (_ inValue: Double) -> Double
    
}

extension HiddenNeuron {
    
    init (_ other: HiddenNeuron) {
        self.init(id: other.id)
        self.bias = other.bias
        self.connections = [Connection]()
    }
    
    // Definition for Neuron.calculate method.
    mutating func calculate () -> Double {
        if storedValue != nil {
            return storedValue!
        } else {
            var sum: Double = 0
            sum += bias
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
    
    // Reset the stored value on the neuron
    mutating func reset () {
        storedValue = nil
    }
    
}
