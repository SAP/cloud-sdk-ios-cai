@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class CardWithButtonRemoteImageTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "Show me products", false),
            CAIResponseMessageData("Laptop Lenovo",
                                   "This is a great Laptop", "https://cdn.cnetcontent.com/d7/8d/d78d88da-e0a1-4607-abc5-991c92223a39.jpg",
                                   nil,
                                   [UIModelDataAction("Order", "Order", .text), UIModelDataAction("Universal", "https://www.youtube.com/watch?v=RXsIah6HvgU", .link)],
                                   nil,
                                   "Available")
        ]
    }

    // MARK: - Tests

    func testFioriTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.fiori(FioriColorPalette()))

        for c in configs {
            assertSnapshot(view, configs: [c], style: .light, delay: 3.0)
            assertSnapshot(view, configs: [c], style: .dark, delay: 3.0)
        }
    }

    func testAppleTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.default(DefaultColorPalette()))

        for c in configs {
            assertSnapshot(view, configs: [c], style: .light, delay: 3.0)
            assertSnapshot(view, configs: [c], style: .dark, delay: 3.0)
        }
    }
}
