@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class QuickReplyListTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        let iButtons = [
            UIModelDataAction("qr type b1", "Reply b1", .text),
            UIModelDataAction("qr type b2", "Reply b2", .text),
            UIModelDataAction("qr type b3", "Reply b3", .text),
            UIModelDataAction("qr type b11", "Reply b11", .text),
            UIModelDataAction("qr type b22", "Reply b22", .text),
            UIModelDataAction("qr type b33", "Reply b33", .text),
            UIModelDataAction("qr type b111", "Reply b111", .text),
            UIModelDataAction("qr type b222", "Reply b222", .text),
            UIModelDataAction("qr type b333", "Reply b333", .text)
        ]

        return [
            CAIResponseMessageData(text: "Any quick replies?", false),
            CAIResponseMessageData(text: "This is Quick Replies", iButtons, buttonType: .quickReplies)
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
