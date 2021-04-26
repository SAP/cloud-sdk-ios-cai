@testable import SAPCAI
import XCTest

final class ThemeManagerTests: XCTestCase {
    func testDefaultThemeColorPalette() {
        XCTAssertEqual(ThemeManager.shared.theme.palette.name, FioriColorPalette().name)
    }
}
