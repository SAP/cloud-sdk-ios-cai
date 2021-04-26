@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class TextMessagesWrappingTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var configs: [SnapshotTestViewConfig] {
        let configs = PresetViewImageConfigs()
        return configs.phones
    }

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "My own long message to analize where text wraps and make sure the container is rendered correctly", false),
            CAIResponseMessageData(text: "My own long message to analize where text wraps and make sure it works", true)
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

    func testAppleTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.default(DefaultColorPalette()))

        for c in self.configs {
            assertSnapshot(view, configs: [c], style: .light)
            assertSnapshot(view, configs: [c], style: .dark)
        }
    }
}
