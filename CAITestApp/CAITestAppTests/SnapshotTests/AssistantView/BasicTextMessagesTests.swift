@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class BasicTextMessagesTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var configs: [SnapshotTestViewConfig] {
        let configs = PresetViewImageConfigs()
        return configs.phones
    }

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "Hi", false),
            CAIResponseMessageData(text: "Hello, what can I do for you today?", true)
        ]
    }

    // MARK: - Tests

    func testFioriTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.fiori(FioriColorPalette()))

        for c in self.configs {
            assertSnapshot(view, configs: [c], style: .light)
            assertSnapshot(view, configs: [c], style: .dark)
        }
    }

    func testCasualTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.casual(CasualColorPalette()))

        for c in self.configs {
            assertSnapshot(view, configs: [c], style: .light)
            assertSnapshot(view, configs: [c], style: .dark)
        }
    }
}
