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
    
    let path: String
    
    // A dictionary of previously queried tables so that a new
    // object does not need to be created with every call for
    // a table.
    private var tables = [String : SQLiteTable]()
    
    init (path: String) {
        self.path = path
        sqlite3_open(path, &ptr)
    }
    
    // Try to close connection on deinit.
    deinit {
        sqlite3_close(ptr)
    }
    
    func dump (to file: String) {
        shell("sqlite3", path, " .dump", " > ", file)
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
    
    // Calls the SQLite command to create a table with a given name
    // and column representation.
    @discardableResult
    func createTable (name: String, _ command: String) -> Bool {
        if let statement = generateStatment("CREATE TABLE \(name)\(command);") {
            return statement.step() == SQLITE_DONE
        } else {
            return false
        }
    }
    
    // Drops a table with a given name.
    @discardableResult
    func dropTable (name: String) -> Bool {
        if let statement = generateStatment("DROP TABLE \(name);") {
            return statement.step() == SQLITE_DONE
        } else {
            return false
        }
    }
    
    // Call the command to close the database.
    // Returns whether close was successful.
    @discardableResult
    func close () -> Bool {
        return sqlite3_close(ptr) == SQLITE_OK
    }
    
}
