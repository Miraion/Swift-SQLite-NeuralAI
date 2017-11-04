//
//  Display.swift
//  project-n
//
//  Created by Jeremy S on 2017-11-03.
//  Copyright © 2017 Jeremy S. All rights reserved.
//

// Singleton object for printing out training progress.
class Display {
    
    static var instance = Display()
    
    // After this many rounds the progress will be printed out.
    var outputInterval = 1
    
    private var nextIndex = 0
    
    // A double array to hold the data recived from learing threads.
    // Each element in the outer array hild the data from a single thread.
    var threadData = [[ProgressDataSet]]()
    
    // Create a given number of outer arrays in threadData so that
    // data can be added by using the thread id as an index.
    func setUp (numThreads: Int) {
        threadData.removeAll()
        for _ in 1...numThreads {
            threadData.append([ProgressDataSet]())
        }
    }
    
    // Inserts a data set into this object.
    // setUp must have been called with the correct number of threads
    // before any data can be added.
    func addData (_ data: ProgressDataSet) {
        threadData[data.threadId].append(data)
    }
    
    // Checks to see if each thread has given enough data to print out
    // as new progress report.
    private func isReadyToPrint () -> Bool {
        for thread in threadData {
            if thread.count - 1 < nextIndex {
                return false
            }
        }
        return true
    }
    
    // Returns a progress report to be printed to stdout if one is ready.
    func getNextDataSet (force: Bool = false) -> String? {
        
        // Return nil if not enough data has been received.
        if !isReadyToPrint() && !force {
            return nil
        }
        
        let indent = String(repeating: " ", count: 10)
        let separator = String(repeating: " ", count: 2)
        
        let numeticalFormat = "%.5f"
        func formatNumerical (_ val: Double) -> String {
            return (val < 0 ? "-" : " ") + String(format: numeticalFormat, abs(val))
        }
        
        let EOL = "\n"
        
        var roundNum = "Report "
        
        if !force {
            roundNum += String(format: "%d", nextIndex)
        } else {
            roundNum += "(forced)"
        }
        
        var header = indent
        var underline = indent
        for i in 0..<threadData.count {
            header      += "Thread \(i)" + separator
            underline   += "--------" + separator
        }
        
        var rowBest     = "Best    : "
        var rowAverage  = "Average : "
        var rowDeltaB   = "Delta B : "
        var rowDeltaA   = "Delta A : "
        
        if !force {
            for thread in threadData {
                rowBest += formatNumerical(thread[nextIndex].best) + separator
                rowAverage += formatNumerical(thread[nextIndex].average) + separator
                rowDeltaB += formatNumerical(thread[nextIndex].changeBest) + separator
                rowDeltaA += formatNumerical(thread[nextIndex].changeAverage) + separator
            }
        } else {
            for thread in threadData {
                rowBest += formatNumerical(thread.last!.best) + separator
                rowAverage += formatNumerical(thread.last!.average) + separator
                rowDeltaB += formatNumerical(thread.last!.changeBest) + separator
                rowDeltaA += formatNumerical(thread.last!.changeAverage) + separator
            }
        }
        
        
        let masterString = (roundNum + EOL
            + header + EOL
            + underline + EOL
            + rowBest + EOL
            + rowAverage + EOL
            + rowDeltaB + EOL
            + rowDeltaA + EOL)
        
        if !force {
            nextIndex += outputInterval
        }
        
        return masterString
    }
    
}
