import Foundation
/**
 Represents what's expected from a logging entity
 */
public protocol Logger {
    
    func debug(_ message: String, file: StaticString, function: StaticString, line: Int)
    
    func info(_ message: String, file: StaticString, function: StaticString, line: Int)
    
    func event(_ message: String, file: StaticString, function: StaticString, line: Int)
    
    func warn(_ message: String, file: StaticString, function: StaticString, line: Int)
    
    func error(_ message: String, file: StaticString, function: StaticString, line: Int)
    
}

public enum LogLevel: Int {
    case debug
    case error
    case warning
    case event
    case info
}

public enum LoggerType {
    case osLog(subsystem: String) // prints to OSLog
    case printerLog // prints to console
    case fileLogger(logsDirectory: URL, alsoPrint: Bool) // prints logs to files
}


public class ZealousLogger {
    
    public static func logger(_ type: LoggerType, level: LogLevel) -> Logger {
        switch type {
        case .fileLogger(let url, let alsoPrint):
            return DDLogger(concreteLogger: LumberjackLogger(logDirectory: url, level: level, alsoPrint: alsoPrint))
        case .osLog(let subsystem):
            return ConsoleLogger(concreteLogger: OsLogLogger(subsystem: subsystem, level: level))
        case .printerLog:
            return ConsoleLogger(concreteLogger: PrinterLogger(level: level))
        }
    }
}
