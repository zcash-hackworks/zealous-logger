import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(zealous_loggerTests.allTests),
    ]
}
#endif
