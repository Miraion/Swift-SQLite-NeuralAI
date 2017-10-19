//
//  main.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-15.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

// Database and table setup
let neuralConfigDatabasePath = "/Users/Jeremy/Desktop/Swift/project-n/databases/NeuralConfig.db"
let neuralConfigDatabase = SQLiteDatabase(path: neuralConfigDatabasePath)
let innovSet = neuralConfigDatabase.table(name: "INNOVSET")

// Neural Network setup
InnovationGenerator.load(from: innovSet)

let network = NeuralNetwork()

// Nodes
network.addNode(InputNeuron(id: 0))
network.addNode(InputNeuron(id: 1))

network.addNode(HiddenSigmoidNeuron(id: 2))
network.addNode(HiddenSigmoidNeuron(id: 3))
network.addNode(HiddenSigmoidNeuron(id: 4))

network.addNode(OutputSigmoidNeuron(id: 5))

// Connections
do {
    try network.addConnection(from: 5, to: 2, weight: 0.6)
    try network.addConnection(from: 5, to: 3, weight: 0.5)
    try network.addConnection(from: 5, to: 4, weight: -0.2)
    
    try network.addConnection(from: 2, to: 0, weight: 0.2)
    try network.addConnection(from: 2, to: 1, weight: 0.5)
    
    try network.addConnection(from: 3, to: 0, weight: 0.8)
    try network.addConnection(from: 3, to: 1, weight: -0.3)
    
    try network.addConnection(from: 4, to: 0, weight: -0.3)
    try network.addConnection(from: 4, to: 1, weight: 0.9)
} catch {
    print("Error constructing connections")
}

try! print(network.solve(for: 1, 1))

neuralConfigDatabase.dropTable(name: "TestNN_NODE")
neuralConfigDatabase.dropTable(name: "TestNN_CONN")

do {
    try network.saveAs("TestNN", in: neuralConfigDatabase)
    print("Save As OK!")
} catch NeuralError.UnableToCreateNewTable {
    print("Error creating table")
} catch {
    print("Error saving network")
}

// Neural Network Teardown
InnovationGenerator.save(to: innovSet)
