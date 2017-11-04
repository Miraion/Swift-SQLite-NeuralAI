//
//  NeuralIOSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-31.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

typealias NeuralIOPair = (in: [Double], out: [Double])

func neuralIOPairDifference (_ base: NeuralIOPair, from ref: NeuralIOPair) throws -> Double {
    if base.in != ref.in {
        throw NeuralError.InvalidComparison
    }
    
    if base.out.count != ref.out.count {
        throw NeuralError.InvalidComparison
    }
    
    var diffs = [Double]()
    for i in 0..<base.out.count {
        diffs.append(abs((ref.out[i] - base.out[i])))
        if DEBUG_PRINT {
            print("ref[\(i)] = \(ref.out[i]) -- base[\(i)] = \(base.out[i])")
        }
    }
    
    let max = diffs.max()!
    
    var sum = 0.0
    for diff in diffs {
        if diff != max {
            sum += diff * 0.1
        }
    }
    
    sum += max
    
    return sum
}

struct NeuralIOSet {
    
    var definitions: [NeuralIOPair]
    
    var inputs: [[Double]] {
        var arr = [[Double]]()
        for pair in definitions {
            arr.append(pair.in)
        }
        return arr
    }
    
    var outputs: [[Double]] {
        var arr = [[Double]]()
        for pair in definitions {
            arr.append(pair.out)
        }
        return arr
    }
    
    init (reference pairs: [NeuralIOPair]) {
        self.definitions = pairs
    }
    
    init? (solve network: NeuralNetwork, inputs: [[Double]]) {
        self.definitions = [NeuralIOPair]()
        
        for input in inputs {
            do {
                let solution = try network.solve(for: input)
                definitions.append(solution)
            } catch {
                print("Error initalizing: input arrays may be of incorrect size")
                return nil
            }
        }
    }
    
    func difference (from reference: NeuralIOSet) throws -> Double {
        var diffs = [Double]()

        if definitions.count != reference.definitions.count {
            throw NeuralError.InvalidComparison
        }

        for i in 0..<definitions.count {
            diffs.append(try neuralIOPairDifference(definitions[i], from: reference.definitions[i]))
        }
        
        let max = diffs.max()!
        
        var sum = 0.0
        for diff in diffs {
            if diff != max {
                sum += diff * 0.1
            }
        }
        
        sum += max

        return sum
    }
}
