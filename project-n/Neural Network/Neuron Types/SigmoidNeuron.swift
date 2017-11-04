//
//  SigmoidNeuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Darwin

class HiddenSigmoidNeuron : HiddenNeuron {
    
    let id: Int
    
    var storedValue: Double? = nil
    
    var bias: Double = 0.0
    
    var connections = [Connection]()
    
    required init (id: Int) {
        self.id = id
    }
    
    func type () -> String {
        return "HS"
    }
    
    func activationFunction(_ inValue: Double) -> Double {
        return tanh(inValue)
    }
}

class OutputSigmoidNeuron : HiddenSigmoidNeuron, OutputNeuron {
    
    override func type () -> String {
        return "OS"
    }
}
