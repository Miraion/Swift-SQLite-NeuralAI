//
//  TLEntity.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-01.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class TLEntity : LearningEntity {

    var network: NeuralNetwork
    
    var differenceValue: Double = 0.0
    
    var value: Double {
        return differenceValue
    }
    
    required init (network: NeuralNetwork) {
        self.network = network
    }
    
    static func < (lhs: TLEntity, rhs: TLEntity) -> Bool {
        return lhs.differenceValue < rhs.differenceValue
    }
    
}
