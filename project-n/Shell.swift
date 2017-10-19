//
// Created by Jeremy S on 2017-07-30.
// Copyright (c) 2017 JeremySchwartz. All rights reserved.
//

import Foundation

/**
 Runs a shell command with given arguments.
 
 - parameter args: The arguments to be passed to the terminal.
 The first argument is the command to be run with each procceding
 argument being the flags passed to the command.
 */
@discardableResult
func shell (_ args: [String]) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

/**
 Runs a shell command with given arguments.
 
 - parameter args: The arguments to be passed to the terminal.
 The first argument is the command to be run with each procceding
 argument being the flags passed to the command.
 */
@discardableResult
func shell (_ args: String ...) -> Int32 {
    return shell(args)
}

/**
 Runs a given command with given flags.
 
 - parameter command: The command to be run.
 
 - parameter flags: The flags to be passed to the command.
 */
@discardableResult
func shell (command: String, flags: [String]) -> Int32 {
    var args = [command]
    args.append(contentsOf: flags)
    return shell(args)
}

/**
 Runs a given command with given flags.
 
 - parameter command: The command to be run.
 
 - parameter flags: The flags to be passed to the command.
 */
@discardableResult
func shell (command: String, flags: String ...) -> Int32 {
    return shell(command: command, flags: flags);
}
