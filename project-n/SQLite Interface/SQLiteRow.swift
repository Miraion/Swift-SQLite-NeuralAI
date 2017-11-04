//
//  SQLiteRow.swift
//  project-n
//
//  Created by Jeremy S on 2017-10-23.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

import Foundation

struct SQLiteRow {
    
    let values: [Any]
    
    var count: Int {
        return values.count
    }
    
    init (_ values: [Any]) {
        self.values = values
    }
    
    init (_ values: Any...) {
        self.values = values
    }
    
    subscript (index: Int) -> Any {
        return values[index]
    }
    
}
