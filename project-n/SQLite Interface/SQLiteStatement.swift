//
//  SQLiteCommand.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-17.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import SQLite3

class SQLiteStatement {
    
    var ptr: OpaquePointer?
    
    init () {
        self.ptr = nil
    }
    
    init (database: SQLiteDatabase, command: String) {
        self.ptr = nil
        prepare(database: database, command: command)
    }
    
    deinit {
        finalize()
    }
    
    @discardableResult
    func prepare (database: SQLiteDatabase, command: String) -> Bool {
        return sqlite3_prepare(database.ptr, command, -1, &ptr, nil) == SQLITE_OK
    }
    
    func step () -> Int32 {
        return sqlite3_step(ptr)
    }
    
    func finalize () {
        sqlite3_finalize(ptr)
    }
    
}
