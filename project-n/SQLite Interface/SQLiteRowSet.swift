//
//  SQLiteRowSet.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-23.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import SQLite3

extension SQLiteDatabase.SQLiteTable {
    
    class SQLiteRowSet {
        
        var statement: SQLiteStatement
        
        private(set) var rows: [SQLiteRow]
        
        // Counter for legacy nextRow method.
        private var nextRowIndex = -1
        
        init (statement: SQLiteStatement) {
            self.statement = statement
            self.rows = [SQLiteRow]()
            
            while statement.step() == SQLITE_ROW {
                let columnNum = sqlite3_column_count(statement.ptr)
                var row = [Any]()
                for i in 0..<columnNum {
                    row.append(pullValue(column: i))
                }
                rows.append(SQLiteRow(row))
            }
        }
        
        subscript (index: Int) -> SQLiteRow {
            return rows[index]
        }
        
        private func pullValue (column: Int32) -> Any {
            switch String(cString: sqlite3_column_decltype(statement.ptr, column)) {
                
            case "INT": return Int(sqlite3_column_int(statement.ptr, column))
                
            case "REAL": return sqlite3_column_double(statement.ptr, column)
                
            case "TEXT": return String(cString: sqlite3_column_text(statement.ptr, column))
                
            default: return sqlite3_column_blob(statement.ptr, column)
                
            }
        }
        
        func finalize () {
            statement.finalize()
        }
        
        // Legacy Methods //
        @discardableResult
        func nextRow () -> Bool {
            nextRowIndex += 1
            if nextRowIndex < rows.count {
                return true
            } else {
                return false
            }
        }
        
        func asInt (column: Int) -> Int {
            return rows[nextRowIndex][column] as! Int
        }
        
        func asText (column: Int) -> String {
            return rows[nextRowIndex][column] as! String
        }
        
        func asDouble (column: Int) -> Double {
            return rows[nextRowIndex][column] as! Double
        }
        
    }
    
}
