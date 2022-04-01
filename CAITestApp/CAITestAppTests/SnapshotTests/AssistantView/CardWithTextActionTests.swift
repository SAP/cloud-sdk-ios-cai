@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class CardWithTextActionTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "Show me products", false),
            CAIResponseMessageData("Laptop Lenovo",
                                   "This is a great Laptop", "sap-icon://order-status",
                                   nil,
                                   [UIModelDataAction("Order2", "Order2", .text)],
                                   nil,
                                   "Available")
        ]
    }

    // MARK: - Tests

    func testFioriTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.fiori(FioriV6ColorPalette()))

        for c in configs {
            assertSnapshot(view, configs: [c], style: .light)
            assertSnapshot(view, configs: [c], style: .dark)
        }
    }

    func testCasualTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.casual(CasualColorPalette()))

        for c in configs {
            assertSnapshot(view, configs: [c], style: .light)
            assertSnapshot(view, configs: [c], style: .dark)
        }
    }
}
