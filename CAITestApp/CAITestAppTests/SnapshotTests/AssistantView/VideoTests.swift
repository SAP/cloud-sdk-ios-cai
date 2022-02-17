@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class VideoTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        [
            CAIResponseMessageData(text: "I want to watch a video", false),
            CAIResponseMessageData(videoUrl: "https://www.youtube.com/watch?v=tOlYWKifhUI")
        ]
    }

    // MARK: - Tests

    func testFioriTheme() throws { // disable test as it does not run reliable
        // let view = getAssistantView(with: messsageData, theme: CAITheme.fiori(FioriV6ColorPalette()))
        // assertSnapshot(view, configs: [SnapshotTestViewConfig(config: .iPhoneX(.portrait), identifier: "iPhoneX_portrait")], style: .light, delay: 3.0)
    }
}
