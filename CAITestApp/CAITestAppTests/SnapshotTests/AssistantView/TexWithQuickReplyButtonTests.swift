@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class TexWithQuickReplyButtonTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "Show me text with quick reply button", false),
            CAIResponseMessageData(text: "Text with quick reply buttons", [
                UIModelDataAction("Text Button", "Button1", .text),
                UIModelDataAction("Link Universal", "https://www.youtube.com/watch?v=RXsIah6HvgU", .link),
                UIModelDataAction("Link URLScheme", "comgooglemaps://?q=Steamers+Lane+Santa+Cruz,+CA&center=37.782652,-122.410126&views=satellite,traffic&zoom=15", .link)
            ], buttonType: .quickReplies)
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
