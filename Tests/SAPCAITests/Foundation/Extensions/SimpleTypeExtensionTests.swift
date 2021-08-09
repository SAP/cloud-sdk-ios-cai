@testable import SAPCAI
import XCTest

final class SimpleTypeExtensionTests: XCTestCase {
    
    /// String  Extension
    func testStringtoTelString() {
        var telString = "tel: +86 13463637643 "
        XCTAssertEqual(telString.toTelURLString(), "tel:+8613463637643")
        
        telString = " +1 650 44 79 539 "
        XCTAssertEqual(telString.toTelURLString(), "tel:+16504479539")
    }
}
