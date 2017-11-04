//
//  Random.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-26.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Darwin

/// Returns a double between 0 and 1 with 3 significant figures.
var randomCleanPositiveDouble: Double {
    return Double(arc4random_uniform(1000)) / 1000.0
}

/// Returns a double between -1 and 1 with 3 signigicant figures.
var randomCleanDouble: Double {
    return 2 * (randomCleanPositiveDouble - 0.5)
}

func randomChance (percent: Int) -> Bool {
    return Int(randomCleanPositiveDouble * 100) < percent
}

func randomRange (_ lowerBound: Double, _ upperBound: Double) -> Double {
    let rand = randomCleanPositiveDouble * (upperBound - lowerBound)
    return lowerBound + rand
}

func randomRange (around ref: Double, size: Double) -> Double {
    return randomRange(ref - (size * 0.5), ref + (size * 0.5))
}

func randomRange (_ lowerBound: Int, _ upperBound: Int) -> Int {
    return lowerBound + Int(arc4random_uniform(UInt32(lowerBound + upperBound)))
}
