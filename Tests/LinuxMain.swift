import XCTest

import ValidateTests

var tests = [XCTestCaseEntry]()
tests += ValidateTests.allTests()
XCTMain(tests)