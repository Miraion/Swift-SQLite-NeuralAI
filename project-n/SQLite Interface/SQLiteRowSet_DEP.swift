//
//  SQLiteRow.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-17.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import SQLite3

extension SQLiteDatabase.SQLiteTable {
    
    // An object to represent a set of rows returned by a SQLite query.
    //
    // nextRow() is not called on object creation but it is called once
    // a request for a column element is received. It may also be called
    // manually to retrieve the first row.
    class SQLiteRowSet_DEP {
        
        var statement: SQLiteStatement
        
        private var isInitialized: Bool = false
        
        init (statement: SQLiteStatement) {
            self.statement = statement
        }
        
        private func initializeIfNotAlready() {
            if !isInitialized {
                nextRow()
            }
        }
        
        func finalize () {
            statement.finalize()
        }
        
        // Moves the row set to the next row from the query.
        // Returns whether there is a next row to move to or not.
        //
        // Example:
        //  while rowSet.nextRow() {
        //      print(rowSet.asText(column: 0))
        //  }
        @discardableResult
        func nextRow () -> Bool {
            isInitialized = true
            return statement.step() == SQLITE_ROW
        }
        
        // Returns the element of the current row at a given column as a certain type.
        func asInt (column: Int32) -> Int {
            initializeIfNotAlready()
            return Int(sqlite3_column_int(statement.ptr, column))
        }
        
        func asText (column: Int32) -> String {
            initializeIfNotAlready()
            return String(cString: sqlite3_column_text(statement.ptr, column))
        }
        
        func asDouble (column: Int32) -> Double {
            initializeIfNotAlready()
            return sqlite3_column_double(statement.ptr, column)
        }
        
    }
    
}
