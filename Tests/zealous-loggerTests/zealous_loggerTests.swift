import XCTest
@testable import zealous_logger

final class zealous_loggerTests: XCTestCase {
    func testFileLogger() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertNotNil(ZealousLogger.logger(.printerLog, level: .debug) as? ConsoleLogger)
        
        
        let url = FileManager.default.temporaryDirectory
        
        let fileLogger = ZealousLogger.logger(.fileLogger(logsDirectory: url, alsoPrint: true), level: .debug)
        fileLogger.debug("test 123", file: #file, function: #function, line: #line)
        
        guard let logfile = try FileManager.default.contentsOfDirectory(atPath: url.path).first(where: { $0.contains(Bundle.main.bundleIdentifier!)})
               else {
            XCTFail("no logfile found! in \(url)")
            return
        }
        let logfilePath = url.appendingPathComponent(logfile).path
        let logAttributes = try FileManager.default.attributesOfItem(atPath: logfilePath)
        
        let firstLogfileSize = logAttributes[FileAttributeKey.size] as! NSNumber
        
        fileLogger.debug("test 123", file: #file, function: #function, line: #line)
        
        let logAttributes2 = try FileManager.default.attributesOfItem(atPath: logfilePath)
        
        let secondLogfileSize = logAttributes2[FileAttributeKey.size] as! NSNumber
        
        XCTAssertGreaterThan(secondLogfileSize.uint64Value,firstLogfileSize.uint64Value)
        
        
    }

    static var allTests = [
        ("testFileLogger", testFileLogger),
    ]
}
