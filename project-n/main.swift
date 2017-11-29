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

//let p1 = GameHumanPlayer()
//let p2 = GameHumanPlayer()
//
//let controller = GameController(display: true)
//print(controller.play(p1, p2))

let database = SQLiteDatabase(path: "/Users/Jeremy/Desktop/Swift/project-n/databases/NeuralConfig.db")
let nodeTable = database.table(name: "ttt_node")
let connTable = database.table(name: "ttt_conn")

//let learningCore = LearningCore<CLSet<GameTrainer>>(config: (in: 9, out: 9, hidden: [15,13]), saveTables: (nodeTable, connTable))
let network = NeuralNetwork()
try! network.load(nodeTable: nodeTable, connTable: connTable)
let learningCore = CLCore(seed: network, saveTables: (nodeTable, connTable))
//let learningCore = CLCore(config: (9,9,[15]), saveTables: (nodeTable, connTable))
//learningCore.train()

//train(name: "xor", xorTrainingSet, xorNetworkConfig, goal: 0.1)

//let config = (in: 9, out: 9, hidden: [15])

//let net2 = NeuralNetwork(copy: network)
//net2.randomizeWeight(chance: 50)
//net2.randomizeBias(chance: 50)

let p1 = GameAIPlayer(network: network)
//let p2 = GameAIPlayer(network: net2)
let p2 = GameHumanPlayer()

let game = GameController(display: true)
print(game.play(p1, p2))
print(game.board)
print(game.play(p2, p1))


let moveSet = NeuralIOSet(reference: [
    (in: [0,0,0,
          0,0,0,
          0,0,0],
     out: [0,0,0,
           0,1,0,
           0,0,0]),
    (in: [-1,-1,0,
           0, 0,0,
           0, 0,0],
     out: [0,0,1,
           0,0,0,
           0,0,0]),
    (in: [-1,0,0,
          -1,0,0,
           0,0,0],
     out: [0,0,0,
           0,0,0,
           1,0,0]),
    (in: [-1, 0,0,
           0,-1,0,
           0, 0,0],
     out: [0,0,0,
           0,0,0,
           0,0,1]),
    (in: [0,-1,0,
          0,-1,0,
          0, 0,0],
     out: [0,0,0,
           0,0,0,
           0,1,0]),
    (in: [0, 0, 0,
          0,-1,-1,
          0, 0, 0],
     out: [0,0,0,
           1,0,0,
           0,0,0]),
    (in: [0, 0, 0,
          0,-1, 0,
          0, 0,-1],
     out: [1,0,0,
           0,0,0,
           0,0,0]),
    (in: [0, 0,0,
          0,-1,0,
          0,-1,0],
     out: [0,1,0,
           0,0,0,
           0,0,0]),
    (in: [ 0, 0,0,
           0,-1,0,
          -1, 0,0],
     out: [0,0,1,
           0,0,0,
           0,0,0]),
    (in: [ 0, 0,0,
          -1,-1,0,
           0, 0,0],
     out: [0,0,0,
           0,0,1,
           0,0,0]),
    (in: [-1, 0,0,
           0,-1,0,
           0, 0,0],
     out: [0,0,0,
           0,0,0,
           0,0,1]),
    (in: [0,0, 0,
          0,0,-1,
          0,0,-1],
     out: [0,0,1,
           0,0,0,
           0,0,0]),
    (in: [0, 0, 0,
          0, 0, 0,
          0,-1,-1],
     out: [0,0,0,
           0,0,0,
           1,0,0]),
    (in: [0,0,-1,
          0,0,-1,
          0,0, 0],
     out: [0,0,0,
           0,0,0,
           0,0,1]),
    (in: [0,-1,-1,
          0, 0, 0,
          0, 0, 0],
     out: [1,0,0,
           0,0,0,
           0,0,0]),
    (in: [ 0, 0,0,
           0, 0,0,
          -1,-1,0],
     out: [0,0,0,
           0,0,0,
           0,0,1]),
    (in: [ 0,0,0,
          -1,0,0,
          -1,0,0],
     out: [1,0,0,
           0,0,0,
           0,0,0])
])

//train(name: "ttt", moveSet, config, goal: 0.5)
//let network = NeuralNetwork()
//try! network.load(nodeTable: nodeTable, connTable: connTable)
//let learningCore = LearningCore<TLSet>(seed: network, target: moveSet, saveTables: (nodeTable, connTable))
//learningCore.train(till: 0.8)
//
