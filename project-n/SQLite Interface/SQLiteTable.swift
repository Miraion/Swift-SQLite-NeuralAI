//
//  Table.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-17.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import SQLite3

extension SQLiteDatabase {
    
    // An object to represent a SQLite table within a database.
    // Contains methods for interacting with said table.
    class SQLiteTable {
        
        private var database: SQLiteDatabase
        
        let name: String
        
        init (database: SQLiteDatabase, name: String) {
            self.database = database
            self.name = name
        }
        
        func select (column: String, where whereText: String? = nil) -> SQLiteRowSet? {
            let statement: SQLiteStatement?
            
            // Create the statement from input strings.
            if let wText = whereText {
                statement = database.generateStatment("SELECT \(column) FROM \(name) WHERE \(wText);")
            } else {
                statement = database.generateStatment("SELECT \(column) FROM \(name);")
            }
            
            if let s = statement {
                return SQLiteRowSet(statement: s)
            } else {
                return nil
            }
        }
        
        // Inserts a given set of values into the table.
        // Returns whether the insertion was successful.
        @discardableResult
        func insert (values: String) -> Bool {
            if let statement = database.generateStatment("INSERT INTO \(name) VALUES \(values);") {
                return statement.step() == SQLITE_DONE
            } else {
                return false
            }
        }
        
        // Updates a value in the table.
        // Returns whether update was successful.
        @discardableResult
        func update (set setText: String, where whereText: String) -> Bool {
            if let statement = database.generateStatment("UPDATE \(name) SET \(setText) WHERE \(whereText);") {
                return statement.step() == SQLITE_DONE
            } else {
                return false
            }
        }
        
        // Deletes values from the table based on a WHERE statement.
        // Returns whether the deletion was successful.
        @discardableResult
        func delete (where whereText: String) -> Bool {
            if let statement = database.generateStatment("DELETE FROM \(name) WHERE \(whereText);") {
                return statement.step() == SQLITE_DONE
            } else {
                return false
            }
        }
        
        // Deletes all entries from this table.
        // Returns whether deletion was successful.
        @discardableResult
        func erase () -> Bool {
            if let statement = database.generateStatment("DELETE FROM \(name);") {
                return statement.step() == SQLITE_DONE
            } else {
                return false
            }
        }
        
    }
    
}
