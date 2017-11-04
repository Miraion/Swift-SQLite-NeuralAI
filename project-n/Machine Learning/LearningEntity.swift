//
//  LearningEntity.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

protocol LearningEntity : Comparable {
    
    var network: NeuralNetwork { get set }
    
    // The value that is used to score this entity.
    // This could be something like a win/loss ratio
    // or a difference value from a desired target.
    var value: Double { get }
    
    init (network: NeuralNetwork)
    
    // From Comparable, explicitly stated here.
    //
    // Note when implementing this method:
    // This method will be used to sort entites in
    // a learning set where the first entity should
    // be the best preforming one.
    //
    // To make this the case, e1 < e2 if and only
    // if e1 preforms better than e2.
    static func < (lhs: Self, rhs: Self) -> Bool
    
}

extension LearningEntity {
    
    // From Comparable.
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
}
