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
    
    private(set) var nodeIdSet = [Int : Neuron]()
    
    // The current solution that was calculated with the solve method.
    // Calling solve again with different inputs will update this value.
    //
    // This variable may be used to referece the solution for the network
    // after it has been calculated without having to calculate again.
    private(set) var currentSolution: NeuralIOPair? = nil
    
    // The number of nodes in this network.
    var count: Int {
        return inputNeurons.count + hiddenNeurons.count + outputNeurons.count
    }
    
    init () {}
    
    init (copy other: NeuralNetwork) {
        for neuron in other.inputNeurons {
            inputNeurons.append(InputNeuron(id: neuron.id))
            nodeIdSet[neuron.id] = inputNeurons.last!
        }
        
        for neuron in other.hiddenNeurons {
            hiddenNeurons.append(HiddenSigmoidNeuron(neuron))
            nodeIdSet[neuron.id] = hiddenNeurons.last!
            for conn in neuron.connections {
                try! addConnection(from: neuron.id, to: conn.targetNeuron.id, weight: conn.weight)
            }
        }
        
        for neuron in other.outputNeurons {
            outputNeurons.append(OutputSigmoidNeuron(neuron))
            nodeIdSet[neuron.id] = outputNeurons.last!
            for conn in neuron.connections {
                try! addConnection(from: neuron.id, to: conn.targetNeuron.id, weight: conn.weight)
            }
        }
    }
    
}


// Computation and network solving
extension NeuralNetwork {
    
    // Convenience overload.
    func solve (for inputValues: Double...) throws -> NeuralIOPair {
        return try solve(for: inputValues)
    }
    
    // Solves the entire network for a given set of inputs.
    func solve (for inputValues: [Double]) throws -> NeuralIOPair {
        // Ensure there is a valid number of given inputs.
        if inputValues.count != inputNeurons.count {
            throw NeuralError.NumberOfInputsDoesNotMatchNumberOfInputNodes
        }
        
        // Set the input values for the network.
        for i in 0..<inputValues.count {
            inputNeurons[i].setValue(to: inputValues[i])
        }
        
        // Reset the hidden and output neurons
        for i in 0..<hiddenNeurons.count {
            hiddenNeurons[i].reset()
        }
        
        for i in 0..<outputNeurons.count {
            outputNeurons[i].reset()
        }
        
        outputNeurons.sort(by: { $0.id < $1.id })
        
        // Calculate the values of the output nodes.
        var outputValues = [Double]()
        for i in 0..<outputNeurons.count {
            outputValues.append(outputNeurons[i].getValue())
            if DEBUG_PRINT {
                print("[\(i)] - \(outputNeurons[i].getValue())")
            }
        }
        
        currentSolution = (in: inputValues, out: outputValues)
        return currentSolution!
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


// Generation and modification
extension NeuralNetwork {
    
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
    
    
    // Adds a given number of nodes to the network with consecutive ids statring at a given value.
    func addNodes (type: String, startId: Int, number: Int) throws {
        for i in 0..<number {
            if let neuron = constructNeuron(type: type, id: startId + i) {
                addNode(neuron)
            } else {
                throw NeuralError.InvalidNodeType
            }
        }
    }
    
    
    // Returns the connection between two given neurons if it exists.
    func findConnection (base: Int, target: Int) -> Connection? {
        if let baseNeuron = nodeIdSet[base] {
            if baseNeuron is HiddenNeuron {
                let neuron = baseNeuron as! HiddenNeuron
                for conn in neuron.connections {
                    if conn.targetNeuron.id == target {
                        return conn
                    }
                }
            }
        }
        return nil
    }
    
    
    // Randomizes a given percentage of this network's weight values of this networks connections
    func randomizeWeight (chance: Int) {
        if randomChance(percent: chance) {
            for innov in InnovationGenerator.innovationValues {
                if let connectionData = InnovationGenerator.getConnectionData(innov: innov) {
                    if let conn = findConnection(base: connectionData.base, target: connectionData.target) {
                        conn.weight = randomCleanDouble
                    }
                }
            }
        }
    }
    
    
    // Changes a given percentage of this network's weights by a small amount
    func tweakWeight (chance: Int, range: Double = 0.2) {
        if randomChance(percent: chance) {
            for innov in InnovationGenerator.innovationValues {
                if let connectionData = InnovationGenerator.getConnectionData(innov: innov) {
                    if let conn = findConnection(base: connectionData.base, target: connectionData.target) {
                        conn.weight = randomRange(around: conn.weight, size: range)
                    }
                }
            }
        }
    }
    
    
    // Randomizes the bias' for all nodes
    func randomizeBias (chance: Int) {
        for node in nodeIdSet.values {
            if randomChance(percent: chance) {
                if node is HiddenNeuron {
                    var neuron = node as! HiddenNeuron
                    neuron.bias = randomCleanDouble
                }
            }
        }
    }
    
    
    // Changes the bias of a node by a little bit
    func tweakBias (chance: Int, range: Double = 0.1) {
        for node in nodeIdSet.values {
            if randomChance(percent: chance) {
                if node is HiddenNeuron {
                    var neuron = node as! HiddenNeuron
                    neuron.bias = randomRange(around: neuron.bias, size: range)
                }
            }
        }
    }
    
    
}


// SQLite interface, loading and saving
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
                let bias = nodeRows.asDouble(column: 2)
                if let neuron = constructNeuron(type: type, id: id) {
                    if neuron is HiddenNeuron {
                        var hNeuron = neuron as! HiddenNeuron
                        hNeuron.bias = bias
                    }
                    addNode(neuron)
                } else {
                    throw NeuralError.InvalidNodeType
                }
            }
        } else {
            throw NeuralError.FailToLoad
        }
        
        // Sort the output nodes by id values
        outputNeurons.sort(by: { $0.id < $1.id })
        
        // Load the connections from the connection table and apply them to the network.
        if let connRows = connTable.select(column: "*") {
            
            while connRows.nextRow() {
                let base = connRows.asInt(column: 1)
                let target = connRows.asInt(column: 2)
                let weight = connRows.asDouble(column: 3)
                
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
        
        let nodes = nodeIdSet.values.sorted(by: { $0.id < $1.id })
        
        for node in nodes {
            // Insert the node into the node network.
            let bias: Double?
            if node is HiddenNeuron {
                bias = (node as! HiddenNeuron).bias
            } else {
                bias = nil
            }
            
            nodeTable.insert("(\(node.id), '\(node.type())', \(bias ?? 0.0))")
            
            // If node has connections, insert all them into the connection table.
            if node is HiddenNeuron {
                let hNode = node as! HiddenNeuron
                for conn in hNode.connections {
                    if !connTable.insert("(\(conn.innovationValue), \(hNode.id), \(conn.targetNeuron.id), \(conn.weight))") {
                        print("Error on insertion of connection")
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
        if !database.createTable(name: "\(name)_node",
"""
(ID INT PRIMARY KEY NOT NULL,
NODETYPE TEXT NOT NULL,
BIAS REAL NOT NULL)
"""
            ) {
            throw NeuralError.UnableToCreateNewTable
        }
        if !database.createTable(name: "\(name)_conn",
"""
(INNOV INT PRIMARY KEY NOT NULL,
BASE INT NOT NULL,
TARGET INT NOT NULL,
WEIGHT REAL NOT NULL)
"""
            )
        {
            throw NeuralError.UnableToCreateNewTable
        }
        
        let nodeTable = database.table(name: "\(name)_node")
        let connTable = database.table(name: "\(name)_conn")
        
        save(nodeTable: nodeTable, connTable: connTable)
        return (nodeTable: nodeTable, connTable: connTable)
    }
}
