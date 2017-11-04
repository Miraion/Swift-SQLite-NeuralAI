//
//  GenericNetwork.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-26.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

typealias NeuralNetworkConfig = (in: Int, out: Int, hidden: [Int])

class RandomNetwork<HiddenType: HiddenNeuron, OutType: OutputNeuron> : NeuralNetwork {
    
    private var __nextNodeId = -1
    
    private var nextNodeId: Int {
        __nextNodeId += 1
        return __nextNodeId
    }
    
    private var currentNodeId: Int {
        return __nextNodeId
    }
    
    private var randomWeight: Double {
        return randomCleanDouble
    }
    
    private var inputIds = [Int]()
    private var hiddenIds = [[Int]]()
    private var outputIds = [Int]()
    
    convenience init (_ config: NeuralNetworkConfig) {
        self.init(in: config.in, out: config.out, hidden: config.hidden)
    }
    
    // Create a fully connected network with random weight values.
    init (in numIn: Int, out numOut: Int, hidden hiddenLayers: [Int]) {
        super.init()
        
        // Node Creation //
        
        // Create the input nodes.
        for _ in 0..<numIn {
            let id = nextNodeId
            inputIds.append(id)
            addNode(InputNeuron(id: id))
        }
        
        // Create the hidden nodes.
        for i in 0..<hiddenLayers.count {
            hiddenIds.append([Int]())
            for _ in 0..<hiddenLayers[i] {
                let id = nextNodeId
                hiddenIds[i].append(id)
                addNode(HiddenType(id: id))
            }
        }
        // Create the output nodes.
        for _ in 0..<numOut {
            let id = nextNodeId
            outputIds.append(id)
            addNode(OutType(id: id))
        }
        
        // Connection Creation //
        for inId in inputIds {
            for hiddenId in hiddenIds[0] {
                try! addConnection(from: hiddenId, to: inId, weight: randomWeight)
            }
        }
        
        for i in 0..<hiddenIds.count {
            let baseLayer: [Int]
            
            if i == hiddenIds.count - 1 {
                baseLayer = outputIds
            } else {
                baseLayer = hiddenIds[i + 1]
            }
            
            let targetLayer = hiddenIds[i]
            
            for base in baseLayer {
                for target in targetLayer {
                    try! addConnection(from: base, to: target, weight: randomWeight)
                }
            }
        }
        
    }
    
}
