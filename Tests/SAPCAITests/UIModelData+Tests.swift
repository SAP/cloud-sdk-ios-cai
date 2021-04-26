@testable import SAPCAI
import XCTest

final class UIModelDataTests: XCTestCase {
    func testDecodingMarkdownAsBool() throws {
        let givenJsonData = #"""
        {
            "type": "text",
            "markdown": true
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelData.self, from: givenJsonData)
        XCTAssertEqual(model.markdown, true)
    }

    func testDecodingMarkdownAsString() throws {
        let givenJsonData = #"""
        {
            "type": "text",
            "markdown": "true"
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelData.self, from: givenJsonData)
        XCTAssertEqual(model.markdown, true)
    }

    func testDecodingDelayAsInt() throws {
        let givenJsonData = #"""
        {
            "type": "text",
            "delay": 5
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelData.self, from: givenJsonData)
        XCTAssertEqual(model.delay, 5)
    }

    func testDecodingDelayAsFloat() throws {
        let givenJsonData = #"""
        {
            "type": "text",
            "delay": 4.5
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelData.self, from: givenJsonData)
        XCTAssertEqual(model.delay, 4.5)
    }

    func testDecodingDelayAsString() throws {
        let givenJsonData = #"""
        {
            "type": "text",
            "delay": "5"
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelData.self, from: givenJsonData)
        XCTAssertEqual(model.delay, 5)
    }
}
