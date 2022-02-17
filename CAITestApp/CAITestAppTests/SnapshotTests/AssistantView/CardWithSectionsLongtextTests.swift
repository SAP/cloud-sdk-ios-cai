@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class CardWithSectionsLongtextTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        let iAttributes = [UIModelDataValue(value: "This is very long item very long item very long item very long item very long item very long item", dataType: "text", rawValue: nil, label: "Item 1", valueState: nil),
                           UIModelDataValue(value: "This is item 2", dataType: "text", rawValue: nil, label: "Item 2", valueState: nil),
                           UIModelDataValue(value: "https://www.hackingwithswift.com/forums/100-days-of-swiftui/how-do-i-restrict-textview-input-to-a-certain-number-of-characters/763", dataType: "link", rawValue: nil, label: "This is a very long Link1", valueState: nil),
                           UIModelDataValue(value: "superlongfirstnamesuperlongfirstnamesuperlongfirstname.superlonglastnamesuperlonglastnamesuperlonglastname@sap.com", dataType: "email", rawValue: nil, label: "Email1", valueState: nil)]
        let iSections = [UIModelDataSection("Section1", iAttributes)]

        return [
            CAIResponseMessageData(text: "Show me products", false),
            CAIResponseMessageData("Laptop Lenovo2",
                                   "This is a great Laptop2",
                                   "sap-icon://order-status",
                                   nil,
                                   [UIModelDataAction("This is very big button", "This is very big button", .text)],
                                   iSections,
                                   "Not Available")
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
