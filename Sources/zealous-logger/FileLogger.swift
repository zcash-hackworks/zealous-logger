//
//  FileLogger.swift
//  
//
//  Created by Francisco Gindre on 3/9/21.
//

import Foundation
#if COCOAPODS
import CocoaLumberjack
#else
import CocoaLumberjackSwift
#endif


class DDLogger: Logger {
    
    var concreteLogger: ConcreteLogger
    
    init(concreteLogger: ConcreteLogger) {
        self.concreteLogger = concreteLogger
    }
    
    public func debug(_ message: String, file: StaticString, function: StaticString, line: Int) {
        DDLogDebug(message, level: toDDLogLevel(.debug), file: file, function: function, line: UInt(line))
    }
    
    public func info(_ message: String, file: StaticString, function: StaticString, line: Int) {
        DDLogInfo(message, level: toDDLogLevel(.debug), file: file, function: function, line: UInt(line))
    }
    
    public func event(_ message: String, file: StaticString, function: StaticString, line: Int) {
        DDLogInfo(message, level: toDDLogLevel(.debug), file: file, function: function, line: UInt(line))
    }
    
    public func warn(_ message: String, file: StaticString, function: StaticString, line: Int) {
        DDLogWarn(message, level: toDDLogLevel(.debug), file: file, function: function, line: UInt(line))
    }
    
    public func error(_ message: String, file: StaticString, function: StaticString, line: Int) {
        DDLogError(message, level: toDDLogLevel(.debug), file: file, function: function, line: UInt(line))
    }
        
}


class LumberjackLogger: ConcreteLogger {

    init(logDirectory: URL, level: LogLevel, alsoPrint: Bool) {
        self.level = level
        let manager = DDLogFileManagerDefault(logsDirectory: logDirectory.path)
        manager.maximumNumberOfLogFiles = 2
        
        let l = DDFileLogger(logFileManager: manager)
        l.maximumFileSize = 1024 * 1024
        l.rollingFrequency = 60 * 60 * 24 * 7 // weekly rollout
        DDLog.add(l, with: toDDLogLevel(level))
        self.fileLogger = l
        l.logFormatter = CustomFileFormatter()
        if alsoPrint {
            let consoleLogger = DDOSLogger(subsystem: Bundle.main.bundleIdentifier, category: "")
            consoleLogger.logFormatter = CustomTerminalFormatter()
            DDLog.add(consoleLogger, with: toDDLogLevel(level))
        }
        
    }
    
    var fileLogger: DDFileLogger
    var level: LogLevel
    
    
    /**
     This function does nothing because DDLog uses a Shared instance architecture where everything goes through the DDLog class shared instance.
     */
    func log(level: LogLevel, message: String, file: StaticString, function: StaticString, line: Int) {
        // This is fine
    }
}
@inlinable
func levelToDDLogFlag(_ level: LogLevel) -> DDLogFlag {
    switch level {
    case .debug:
        return .debug
    case .error:
        return .error
    case .info:
        return .info
    case .event:
        return .info
    case .warning:
        return .warning
    }
}

@inlinable
func toDDLogLevel(_ level: LogLevel) -> DDLogLevel {
    switch level {
    case .debug:
        return .all
    case .error:
        return .error
    case .event:
        return .info
    case .info:
        return .info
    case .warning:
        return .warning
    }
}

extension DateFormatter {
    static func logDateFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "y-MM-dd H:m:ss.SSSSZ"
        f.timeZone = TimeZone.current
        return f
    }
}

class CustomFileFormatter: NSObject, DDLogFormatter {
    let dateFormatter: DateFormatter = DateFormatter.logDateFormatter()
    
    func format(message logMessage: DDLogMessage) -> String? {
        String(format: "%@ - Thread: %@ - %@- Line %u - %@ - %@",
               dateFormatter.string(from: logMessage.timestamp),
               logMessage.threadID,
               logMessage.fileName,
               logMessage.line,
               logMessage.function ?? "noFunctionName",
               logMessage.message)
    }
}

class CustomTerminalFormatter: NSObject, DDLogFormatter {
    let dateFormatter: DateFormatter = DateFormatter.logDateFormatter()
    
    func format(message logMessage: DDLogMessage) -> String? {
        String(format: "%@[%u] - %@ - %@",
              
               logMessage.fileName,
               logMessage.line,
               logMessage.function ?? "noFunctionName",
               logMessage.message)
    }
}
