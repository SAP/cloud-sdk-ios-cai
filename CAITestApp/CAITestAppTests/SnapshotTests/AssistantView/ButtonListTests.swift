@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class ButtonListTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        let iButtons = [
            UIModelDataAction("button type b1", "b1", .text),
            UIModelDataAction("button type b2", "b2", .text),
            UIModelDataAction("button type b3", "b3", .text),
            UIModelDataAction("button type b4", "b4", .text),
            UIModelDataAction("button type b5", "b5", .text),
            UIModelDataAction("button type b6", "b6", .text),
            UIModelDataAction("button type b7", "b7", .text),
            UIModelDataAction("button type b8", "b8", .text),
            UIModelDataAction("button type b9", "b9", .text),
            UIModelDataAction("button type b10", "b10", .text),
            UIModelDataAction("button type b11", "b11", .text),
            UIModelDataAction("button type b12", "b12", .text),
            UIModelDataAction("button type b13", "b13", .text),
            UIModelDataAction("button type b14", "b14", .text),
            UIModelDataAction("button type b15", "b15", .text),
            UIModelDataAction("button type b16 hidden", "b16", .text)
        ]

        return [
            CAIResponseMessageData(text: "Do you have a list of buttons?", false),
            CAIResponseMessageData(text: "This is buttons", iButtons, buttonType: .buttons)
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
