//
//  NeuralConnectionDataSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//
//  A Hashable object to represent the existance of a connection
//  between to Neuron objects. This is not the actual connection
//  object this is just a representation of the connection.

struct NeuralConnectionDataSet : Hashable {
    let base: Int
    let target: Int
    
    init (from base: Int, to target: Int) {
        self.base = base
        self.target = target
    }
    
    init (from base: Neuron, to target: Neuron) {
        self.base = base.id
        self.target = target.id
    }
    
    init (_ tuple: (Int, Int)) {
        self.base = tuple.0
        self.target = tuple.1
    }
    
    static func == (_ lhs: NeuralConnectionDataSet, _ rhs: NeuralConnectionDataSet) -> Bool {
        return lhs.base == rhs.base && lhs.target == rhs.target
    }
    
    static func == (_ lhs: NeuralConnectionDataSet, _ rhs: (Int, Int)) -> Bool {
        return lhs.base == rhs.0 && lhs.target == rhs.1
    }
    
    var hashValue: Int {
        return base ^ target
    }
}
