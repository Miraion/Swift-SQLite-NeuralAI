//
//  main.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-15.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

let db = SQLiteDatabase(path: "/Users/Jeremy/Desktop/DatabaseTest/TestDB.db")

let table = db.table(name: "people")

let tableRowSet = table.select(column: "*")

if let rowSet = tableRowSet {
    while rowSet.nextRow() {
        print("\(rowSet.asInt(column: 0)) | \(rowSet.asText(column: 1)) | \(rowSet.asInt(column: 2))")
    }
}

tableRowSet?.finalize()

if db.close() {
    print("Close OK!")
} else {
    print("Error closing database")
}
