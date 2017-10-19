//
//  OutputNeuron.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

protocol OutputNeuron : HiddenNeuron {}

extension OutputNeuron {
    
    mutating func getValue () -> Double {
        return calculate()
    }
    
}
