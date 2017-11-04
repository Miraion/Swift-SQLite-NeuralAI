//
//  InputNeuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class InputNeuron : Neuron {
    
    private var fireValue: Double = 0
    
    let id: Int
    
    required init (id: Int) {
        self.id = id
    }
    
    func type () -> String {
        return "I"
    }
    
    func setValue (to value: Double) {
        self.fireValue = value
    }
    
    // Overload for calculate function.
    // Returns the value set with set value.
    func calculate () -> Double {
        return fireValue
    }
    
}
