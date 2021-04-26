@testable import SAPCAI
import XCTest

final class UIModelDataContentTests: XCTestCase {
    func testDecodingTotalAsString() throws {
        let givenJsonData = #"""
        {
            "total": "100"
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelDataContent.self, from: givenJsonData)
        XCTAssertEqual(model.total, 100)
    }

    func testDecodingTotalAsInt() throws {
        let givenJsonData = #"""
        {
            "total": 10
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelDataContent.self, from: givenJsonData)
        XCTAssertEqual(model.total, 10)
    }

    func testDecodingTotalAsFloat() throws {
        let givenJsonData = #"""
        {
            "total": 11.1
        }
        """#.data(using: .utf8)!
        let model = try JSONDecoder().decode(UIModelDataContent.self, from: givenJsonData)
        XCTAssertEqual(model.total, 11)
    }

    func testDecodingUnknownTotalThrowsAnError() throws {
        let givenJsonData = #"""
        {
            "total": true
        }
        """#.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(UIModelDataContent.self, from: givenJsonData))
    }
}
