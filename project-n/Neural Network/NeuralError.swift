//
//  NeuralError.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

enum NeuralError : Error {
    
    // Network constructing errors
    case NodeDoesNotExist
    case AttemptToConnectInputNodeToAnotherNode
    case InvalidNodeType
    
    // Network IO errors
    case UnableToCreateNewTable
    case FailToLoad
    
    // Network evaluation errors
    case NumberOfInputsDoesNotMatchNumberOfInputNodes
    
    // Machine Learning errors
    case InvalidComparison
    
}
