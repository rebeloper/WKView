import XCTest
@testable import WKView

final class WKViewTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WKView().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
