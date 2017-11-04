//
//  Helper.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-04.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func shuffle () {
        for i in 0..<count {
            swapAt(i, randomRange(0, count))
        }
    }
    
    func circularStride (start: Int, distance: Int) -> Element {
        var c = start + distance
        while c >= count {
            c -= count
        }
        return self[c]
    }
    
}
