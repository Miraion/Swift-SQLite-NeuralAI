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

extension Character {
    
    func isDigit () -> Bool {
        return self == "0"
            || self == "1"
            || self == "2"
            || self == "3"
            || self == "4"
            || self == "5"
            || self == "6"
            || self == "7"
            || self == "8"
            || self == "9"
    }
    
    func asDigit () -> Int? {
        let digitSet: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        for i in 0..<digitSet.count {
            if self == digitSet[i] {
                return i
            }
        }
        return nil
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
}
