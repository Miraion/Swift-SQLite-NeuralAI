//
//  main.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-15.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Darwin
import Foundation

var DEBUG_PRINT = false

func normalize (_ input: [Double]) -> String {
    var normalizedOutput = "["
    for i in 0..<input.count {
        normalizedOutput += String(format: "%.3f", input[i])
        if i != (input.count - 1) {
            normalizedOutput += ", "
        }
    }
    normalizedOutput += "]"
    return normalizedOutput
}

func binaryNormalize (_ input: [Double]) -> [Int] {
    var norm = [Int]()
    for val in input {
        norm.append(val < 0.5 ? 0 : 1)
    }
    return norm
}

func train (name: String, _ referenceSet: NeuralIOSet, _ config: (Int, Int, [Int]), goal: Double) {
    
    let database = SQLiteDatabase(path: "/Users/Jeremy/Desktop/Swift/project-n/databases/NeuralConfig.db")
    
    let nodeTable = database.table(name: name + "_node")
    let connTable = database.table(name: name + "_conn")
    
    let learningCore = LearningCore<TLSet>(config: config, target: referenceSet, saveTables: (nodeTable, connTable))
    learningCore.train(till: goal)
}

func runTest (name: String, inputs: [[Double]]) {
    let netLoad = NeuralNetwork()
    let database = SQLiteDatabase(path: "/Users/Jeremy/Desktop/Swift/project-n/databases/NeuralConfig.db")
    let nodeTable = database.table(name: name + "_node")
    let connTable = database.table(name: name + "_conn")
    
    do {
        try netLoad.load(nodeTable: nodeTable, connTable: connTable)
        for input in inputs {
            let solution = try netLoad.solve(for: input)
            
            print("in: \(solution.in) -> out: \(normalize(solution.out))")
        }
    } catch {
        print("Something went wrong")
    }
}


// ========================================================== //

let combinationTrainingSet = NeuralIOSet(reference: [
    (in: [0,0,0,0], out: [0,0]),
    (in: [1,0,0,0], out: [0.5,0]),
    (in: [0,1,0,0], out: [0.5,0]),
    (in: [1,1,0,0], out: [1,0]),
    (in: [0,0,0,1], out: [0,0.5]),
    (in: [0,0,1,0], out: [0,0.5]),
    (in: [0,0,1,1], out: [0,1])
])

let combinationNetworkConfig = (in: 4, out: 2, hidden: [3])


//train(name: "neg_string", combinationTrainingSet, combinationNetworkConfig, goal: 0.15)
//runTest(name: "neg_string", inputs: combinationTrainingSet.inputs)


let xorTrainingSet = NeuralIOSet(reference: [
    (in: [0,0], out: [0]),
    (in: [0,1], out: [1]),
    (in: [1,0], out: [1]),
    (in: [1,1], out: [0])
])

let xorNetworkConfig = (in: 2, out: 1, hidden: [3])

train(name: "xor", xorTrainingSet, xorNetworkConfig, goal: 0.05)
runTest(name: "xor", inputs: xorTrainingSet.inputs)

