//
//  Neuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

protocol Neuron {
    
    var id: Int { get }
    
    func type () -> String
    
    mutating func calculate () -> Double
    
}

// Constructs a neuron from a given type and id.
// Ensure to update this function for new neuron types.
func constructNeuron (type: String, id: Int) -> Neuron? {
    switch (type) {
        
    case "I": return InputNeuron(id: id)
        
    case "HTT": return HiddenTernaryThresholdNeuron(id: id)
    case "OTT": return OutputTernaryThresholdNeuron(id: id)
        
    case "HBT": return HiddenBinaryThresholdNeuron(id: id)
    case "OBT": return OutputBinaryThresholdNeuron(id: id)
        
    case "HS": return HiddenSigmoidNeuron(id: id)
    case "OS": return OutputSigmoidNeuron(id: id)
        
    default: return nil
    }
}
