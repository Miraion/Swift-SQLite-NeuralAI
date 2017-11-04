//
//  OutputSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-20.
//  Copyright © 2017 Jeremy S. All rights reserved.
//


// An object to represent the output of a neural network.
// Provides a method to determin a nemerical values that
// represents how different a given output set is relative
// to a reference set. This may be used in backpropagation
// or in evolution to determine fitness values for a network.
class OutputSet {
    
    let entities: [Double]
    
    var count: Int {
        return entities.count
    }
    
    init (_ entities: [Double]) {
        self.entities = entities
    }
    
    convenience init (_ entities: Double...) {
        self.init(entities)
    }
    
    subscript (index: Int) -> Double {
        get {
            return entities[index]
        }
    }
    
    // Returns the difference between two output sets.
    // Differnece is determined by the net difference
    // of all the elements in each set.
    //
    // Throws GeneralError.ComparingArraysOfDifferentSizes
    // if the two sets contain a different number of elements.
    func difference (from other: OutputSet) throws -> Double {
        // Assert same size arrays
        if count != other.count {
            throw GeneralError.ComparingArraysOfDifferentSizes
        }
        
        var diff = 0.0
        for i in 0..<entities.count {
            diff += abs(other.entities[i] - entities[i])
        }
        
        return diff
    }
}

// Sorts an array of outputs sets based on how closely they match a reference set.
func sort (_ sets: [OutputSet], against ref: OutputSet) throws -> [OutputSet] {
    return try sets.sorted(by: { try $0.difference(from: ref) < $1.difference(from: ref) })
}

