//
//  InnovationGenerator.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-18.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

class InnovationGenerator {
    
    private static var nextInnovValue: Int = 0
    
    private static var innovDatabase = Dictionary<NeuralConnectionDataSet, Int>()
    
    // Generates an innovation value for a given connection, creates a new one if needed.
    static func generate (from base: Neuron, to target: Neuron) -> Int {
        return generate(from: base.id, to: target.id)
    }
    
    static func generate (from base: Int, to target: Int) -> Int {
        if let innov = innovDatabase[NeuralConnectionDataSet(from: base, to: target)] {
            // If innovation value for this connection already exists, return it.
            return innov
        } else {
            // Otherwise, create a new value, add it to the database, then return it.
            let newVal = nextInnovValue
            nextInnovValue += 1
            innovDatabase[NeuralConnectionDataSet(from: base, to: target)] = newVal
            return newVal
        }
    }
    
    // Saves contents of innovDatabase into a SQLite table with column configuration:
    //      INNOV (INT) | BASE (INT) | TARGET (INT)
    static func save (to table: SQLiteDatabase.SQLiteTable) {
        table.erase()
        for kv in innovDatabase {
            table.insert("(\(kv.value), \(kv.key.base), \(kv.key.target))")
        }
    }
    
    // Loads the contents of a SQLite table into innovDatabase. Database format must
    // be as specified above.
    static func load (from table: SQLiteDatabase.SQLiteTable) {
        if let data = table.select(column: "*") {
            while data.nextRow() {
                let bt = NeuralConnectionDataSet(from: data.asInt(column: 1), to: data.asInt(column: 2))
                innovDatabase[bt] = data.asInt(column: 0)
            }
            data.finalize()
        }
    }
    
}
