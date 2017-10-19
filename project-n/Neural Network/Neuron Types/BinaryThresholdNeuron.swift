//
//  BinaryThresholdNeuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class HiddenBinaryThresholdNeuron : HiddenNeuron {
    
    let id: Int
    
    var storedValue: Double? = nil
    
    var threshold: Double
    
    var connections = [Connection]()
    
    init (id: Int, threshold: Double = 0) {
        self.id = id
        self.threshold = threshold
    }
    
    func type () -> String {
        return "HBT"
    }
    
    // Binary threshold activation function:
    //      if inValue is >= threshold return 1 else return 0
    func activationFunction(_ inValue: Double) -> Double {
        return inValue >= threshold ? 1 : 0
    }
}

class OutputBinaryThresholdNeuron : HiddenBinaryThresholdNeuron, OutputNeuron {
    
    override func type () -> String {
        return "OBT"
    }
}
