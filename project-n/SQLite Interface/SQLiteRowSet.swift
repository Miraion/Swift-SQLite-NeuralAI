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
    class SQLiteRowSet {
        
        private var statement: SQLiteStatement
        
        private var isInitalized: Bool = false
        
        private func initalizeIfNotAlready () {
            if !isInitalized {
                nextRow()
            }
        }
        
        init (statement: SQLiteStatement) {
            self.statement = statement
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
            isInitalized = true
            return statement.step() == SQLITE_ROW
        }
        
        // Returns the element of the current row at a given column as a certian type.
        func asInt (column: Int32) -> Int {
            initalizeIfNotAlready()
            return Int(sqlite3_column_int(statement.ptr, column))
        }
        
        func asText (column: Int32) -> String {
            initalizeIfNotAlready()
            return String(cString: sqlite3_column_text(statement.ptr, column))
        }
        
        func asDouble (column: Int32) -> Double {
            initalizeIfNotAlready()
            return sqlite3_column_double(statement.ptr, column)
        }
        
    }
    
}
