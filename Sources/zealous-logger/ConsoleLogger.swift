//
//  ConsoleLogger.swift
//  
//
//  Created by Francisco Gindre on 3/8/21.
//

import Foundation
import os

#if COCOAPODS
import CocoaLumberjack
#else
import CocoaLumberjackSwift
#endif


protocol ConcreteLogger {
    func log(level: LogLevel, message: String, file: StaticString, function: StaticString, line: Int)
    var level: LogLevel { get  }
}

class ConsoleLogger: Logger {

    var concreteLogger: ConcreteLogger
    
    init(concreteLogger: ConcreteLogger) {
        self.concreteLogger = concreteLogger
    }
    
    func debug(_ message: String, file: StaticString, function: StaticString, line: Int) {
        guard concreteLogger.level.rawValue == LogLevel.debug.rawValue else { return }
        concreteLogger.log(level: concreteLogger.level, message: message, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: StaticString, function: StaticString, line: Int) {
        guard concreteLogger.level.rawValue <= LogLevel.error.rawValue else { return }
        concreteLogger.log(level: concreteLogger.level, message: message, file: file, function: function, line: line)
    }
    
    func warn(_ message: String, file: StaticString, function: StaticString, line: Int) {
        guard concreteLogger.level.rawValue <= LogLevel.warning.rawValue else { return }
        concreteLogger.log(level: concreteLogger.level, message: message, file: file, function: function, line: line)
    }

    func event(_ message: String, file: StaticString, function: StaticString, line: Int) {
        guard concreteLogger.level.rawValue <= LogLevel.event.rawValue else { return }
        concreteLogger.log(level: concreteLogger.level, message: message, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: StaticString, function: StaticString, line: Int) {
        guard concreteLogger.level.rawValue <= LogLevel.info.rawValue else { return }
        concreteLogger.log(level: concreteLogger.level, message: message, file: file, function: function, line: line)
    }
}

class OsLogLogger: ConcreteLogger {

    var level: LogLevel
    
    var oslog: OSLog
    
    init(subsystem: String, level: LogLevel) {
        self.level = level
        self.oslog = OSLog(subsystem: subsystem, category: "logs")
    }
    
    private func describeLevel(_ level: LogLevel) -> String  {
        switch level {
        case .debug:
            return "DEBUG 🐞"
        case .error:
            return "ERROR 💥"
        case .event:
            return "EVENT ⏱"
        case .info:
            return "INFO ℹ️"
        case .warning:
            return "WARNING ⚠️"
        }
    }
    
    func log(level: LogLevel, message: String, file: StaticString, function: StaticString, line: Int) {
        let fileName = (String(describing: file) as NSString).lastPathComponent
        
        os_log("[%{public}@] %{public}@ - %{public}@ - Line: %{public}d -> %{public}@", log: oslog, describeLevel(level), fileName, String(describing: fileName), line, message)
    }
}

class PrinterLogger: ConcreteLogger {
    
    var level: LogLevel
    
    init(level: LogLevel) {
        self.level = level
    }
    
    func log(level: LogLevel, message: String, file: StaticString, function: StaticString, line: Int) {
        let filename = (String(describing: file) as NSString).lastPathComponent
        print("[\(level)] \(filename) - \(function) - line: \(line) -> \(message)")
    }
}
