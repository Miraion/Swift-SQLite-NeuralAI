//
//  ThresholdNeuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class HiddenTernaryThresholdNeuron : HiddenNeuron {
    
    let id: Int
    
    var storedValue: Double? = nil
    
    var bias: Double = 0.0
    
    var threshold: Double
    
    var connections = [Connection]()
    
    required init (id: Int) {
        self.id = id
        self.threshold = 0
    }
    
    init (id: Int, threshold: Double) {
        self.id = id
        self.threshold = threshold
    }
    
    func type () -> String {
        return "HTT"
    }
    
    // Ternary threshold activation function:
    //      if inValue == threshold then return 0
    //      else return whether inValue is larger or
    //      smaller than the threshold (1, -1)
    func activationFunction(_ inValue: Double) -> Double {
        if inValue == threshold {
            return 0
        } else {
            return inValue < threshold ? -1 : 1
        }
    }
}


class OutputTernaryThresholdNeuron : HiddenTernaryThresholdNeuron, OutputNeuron {
    
    override func type () -> String {
        return "OTT"
    }
}
