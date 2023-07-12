import XCTest
@testable import ScrapWKWebView

final class ScrapWKWebViewTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let webView = ScrapWKWebView(url: "https://google.com", timeout: 2.0) { html in
            print("HTML: \(html)")
        }
        
    }
}
