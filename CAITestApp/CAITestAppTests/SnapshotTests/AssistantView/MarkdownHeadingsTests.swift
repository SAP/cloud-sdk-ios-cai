@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class MarkdownHeadingsTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "Yet another question to my bot", false),
            CAIResponseMessageData(text: "# Heading1 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true),
            CAIResponseMessageData(text: "## Heading2 head", true, markdown: true),
            CAIResponseMessageData(text: "### Heading3 head", true, markdown: true),
            CAIResponseMessageData(text: "#### Heading4 head", true, markdown: true),
            CAIResponseMessageData(text: "##### Heading5 head", true, markdown: true),
            CAIResponseMessageData(text: "###### Heading6 head", true, markdown: true)
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
