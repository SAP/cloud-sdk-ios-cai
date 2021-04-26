@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class ImageTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var configs: [SnapshotTestViewConfig] {
        let configs = PresetViewImageConfigs()
        return configs.phones
    }

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "Please show me a picture of a Mustang on a race track and some hops", false),
            CAIResponseMessageData(imageName: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/2019-mustang-shelby-gt350-101-1528733363.jpg?crop=0.817xw:1.00xh;0.149xw,0&resize=640:*"),
            CAIResponseMessageData(imageName: "https://pbs.twimg.com/profile_images/3740869426/dfbd05510a00d82ba3acd1d5b9049c43.png")
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
