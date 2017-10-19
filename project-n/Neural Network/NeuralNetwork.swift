//
//  NeuralNetwork.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class NeuralNetwork {
    
    private(set) var inputNeurons = [InputNeuron]()
    private(set) var hiddenNeurons = [HiddenNeuron]()
    private(set) var outputNeurons = [OutputNeuron]()
    
    private(set) var connections = [NeuralConnectionDataSet : Int]()
    
    private(set) var nodeIdSet = [Int : Neuron]()
    
    // The number of nodes in this network.
    var count: Int {
        return inputNeurons.count + hiddenNeurons.count + outputNeurons.count
    }
    
}


// Computation and network solving
extension NeuralNetwork {
    
    // Convenience overload.
    func solve (for inputValues: Double...) throws -> [Double] {
        return try solve(for: inputValues)
    }
    
    // Solves the entire network for a given set of inputs.
    func solve (for inputValues: [Double]) throws -> [Double] {
        // Ensure there is a valid number of given inputs.
        if inputValues.count != inputNeurons.count {
            throw NeuralError.NumberOfInputsDoesNotMatchNumberOfInputNodes
        }
        
        // Set the input values for the network.
        for i in 0..<inputValues.count {
            inputNeurons[i].setValue(to: inputValues[i])
        }
        
        // Calculate the values of the output nodes.
        var outputValues = [Double]()
        for i in 0..<outputNeurons.count {
            outputValues.append(outputNeurons[i].getValue())
        }
        
        return outputValues
    }
    
    // Solves a single output for a given set of inputs.
    func solveForOutput (index: Int, inputs: [Double]) throws -> Double {
        // Ensure there is a valid number of given inputs.
        if inputs.count != inputNeurons.count {
            throw NeuralError.NumberOfInputsDoesNotMatchNumberOfInputNodes
        }
        
        // Set the input values for the network.
        for i in 0..<inputs.count {
            inputNeurons[i].setValue(to: inputs[i])
        }
        
        return outputNeurons[index].getValue()
    }
}


// I/O SQLite interface, loading and saving
extension NeuralNetwork {
    
    // Constructs this network from a layout supplied in a SQLite table.
    //  Node Table Columns: (name_NODE)
    //      ID (INT) | TYPE (TEXT)
    //
    //  Connection Table Columns: (name_CONN)
    //      BASE (INT) | TARGET (INT) | WEIGHT (DOUBLE)
    func load (nodeTable: SQLiteDatabase.SQLiteTable, connTable: SQLiteDatabase.SQLiteTable) throws {
        
        // Load the nodes from the node table into this network.
        if let nodeRows = nodeTable.select(column: "*") {
            
            while nodeRows.nextRow() {
                let id = nodeRows.asInt(column: 0)
                let type = nodeRows.asText(column: 1)
                if let neuron = constructNeuron(type: type, id: id) {
                    addNode(neuron)
                } else {
                    throw NeuralError.InvalidNodeType
                }
            }
        } else {
            throw NeuralError.FailToLoad
        }
        
        // Load the connections from the connection table and apply them to the network.
        if let connRows = connTable.select(column: "*") {
            
            while connRows.nextRow() {
                let base = connRows.asInt(column: 0)
                let target = connRows.asInt(column: 1)
                let weight = connRows.asDouble(column: 2)
                
                try addConnection(from: base, to: target, weight: weight)
            }
        } else {
            throw NeuralError.FailToLoad
        }
    }
    
    // Writes the contents of this network into a SQLite table.
    func save (nodeTable: SQLiteDatabase.SQLiteTable, connTable: SQLiteDatabase.SQLiteTable) {
        // Erase tables to have a clean start.
        nodeTable.erase()
        connTable.erase()
        
        for kv in nodeIdSet {
            // Insert the node into the node network.
            nodeTable.insert("(\(kv.key), '\(kv.value.type())')")
            
            // If node has connections, insert all them into the connection table.
            if kv.value is HiddenNeuron {
                let node = kv.value as! HiddenNeuron
                for conn in node.connections {
                    if !connTable.insert("(\(conn.innovationValue), \(node.id), \(conn.targetNeuron.id), \(conn.weight))") {
                        print("(\(conn.innovationValue), \(node.id), \(conn.targetNeuron.id), \(conn.weight))")
                    }
                }
            }
        }
    }
    
    // Creates two new tables and save the contents of this network into them.
    @discardableResult
    func saveAs (_ name: String, in database: SQLiteDatabase) throws ->
        (nodeTable: SQLiteDatabase.SQLiteTable, connTable: SQLiteDatabase.SQLiteTable)
    {
        if !database.createTable(name: "\(name)_NODE", "(ID INT PRIMARY KEY NOT NULL, NODETYPE TEXT NOT NULL)") {
            throw NeuralError.UnableToCreateNewTable
        }
        if !database.createTable(name: "\(name)_CONN",
"""
( INNOV INT PRIMARY KEY NOT NULL,
BASE INT NOT NULL,
TARGET INT NOT NULL,
WEIGHT REAL NOT NULL)
"""
            )
        {
            throw NeuralError.UnableToCreateNewTable
        }
        
        let nodeTable = database.table(name: "\(name)_NODE")
        let connTable = database.table(name: "\(name)_CONN")
        
        save(nodeTable: nodeTable, connTable: connTable)
        return (nodeTable: nodeTable, connTable: connTable)
    }
    
    // Adds a node to the correct array and to the id set.
    func addNode (_ node: Neuron) {
        if node is InputNeuron {
            inputNeurons.append(node as! InputNeuron)
        } else if node is OutputNeuron {
            outputNeurons.append(node as! OutputNeuron)
        } else {
            hiddenNeurons.append(node as! HiddenNeuron)
        }
        nodeIdSet[node.id] = node
    }
    
    // Adds a connection between two nodes.
    // Throws NeuralError.NodeDoesNotExist if unable to find any of the two nodes.
    // Throws NeuralError.AttemptToConnectInputNodeToAnotherNode if the base node
    //  does not conform to HiddenNode protocal
    func addConnection (from base: Int, to target: Int, weight: Double) throws {
        if let baseNode = nodeIdSet[base] {
            if baseNode is HiddenNeuron {
                var hNode = baseNode as! HiddenNeuron
                if let targetNode = nodeIdSet[target] {
                    
                    // Create connection
                    let innov = InnovationGenerator.generate(from: base, to: target)
                    hNode.addConnection(to: targetNode, weight: weight, innov: innov)
                    
                } else {
                    throw NeuralError.NodeDoesNotExist
                }
            } else {
                throw NeuralError.AttemptToConnectInputNodeToAnotherNode
            }
        } else {
            throw NeuralError.NodeDoesNotExist
        }
    }
}
