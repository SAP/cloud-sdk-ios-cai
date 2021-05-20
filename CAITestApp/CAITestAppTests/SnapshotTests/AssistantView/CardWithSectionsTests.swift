@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class CardWithSectionsTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        let iAttributes = [UIModelDataValue(value: "This is item 1", dataType: "text", rawValue: nil, label: "Item 1", valueState: nil),
                           UIModelDataValue(value: "This is item 2", dataType: "text", rawValue: nil, label: "Item 2", valueState: nil),
                           UIModelDataValue(value: "https://www.sap.com", dataType: "link", rawValue: nil, label: "Link1", valueState: nil),
                           UIModelDataValue(value: "https://www.youtube.com", dataType: "link", rawValue: nil, label: "Link2", valueState: nil),
                           UIModelDataValue(value: "+1-408-464-3537", dataType: "phonenumber", rawValue: nil, label: "Phone1", valueState: nil),
                           UIModelDataValue(value: "john.smith@acme.com", dataType: "email", rawValue: nil, label: "Email1", valueState: nil)]
        let iSections = [UIModelDataSection("Section1", iAttributes)]

        return [
            CAIResponseMessageData(text: "Show me products", false),
            CAIResponseMessageData("Laptop Lenovo2",
                                   "This is a great Laptop2",
                                   "sap-icon://order-status",
                                   nil,
                                   [UIModelDataAction("Order3", "Order3", .text)],
                                   iSections,
                                   "Not Available")
        ]
    }

    // MARK: - Tests

    func testFioriTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.fiori(FioriColorPalette()))

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
