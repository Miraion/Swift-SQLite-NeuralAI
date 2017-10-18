//
//  Database.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-17.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import SQLite3

class SQLiteDatabase {
    
    var ptr: OpaquePointer? = nil
    
    private var tables = [String : SQLiteTable]()
    
    init (path: String) {
        sqlite3_open(path, &ptr)
    }
    
    deinit {
        sqlite3_close(ptr)
    }
 
    // Creates and prepares a statement.
    // Returns nil if unable to prepare the statement.
    func generateStatment (_ command: String) -> SQLiteStatement? {
        let statement = SQLiteStatement()
        if statement.prepare(database: self, command: command) {
            return statement
        } else {
            return nil
        }
    }
    
    // Returns a table object with a given name.
    // Stores a dictionary of queried tables so a new table
    // does not need to be created if it has been queried before.
    func table (name: String) -> SQLiteTable {
        if let t = tables[name] {
            return t
        } else {
            tables[name] = SQLiteTable(database: self, name: name)
            return tables[name]!
        }
    }
    
    func close () -> Bool {
        return sqlite3_close(ptr) == SQLITE_OK
    }
    
}
