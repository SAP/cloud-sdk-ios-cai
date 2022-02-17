@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class CarouselTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var messsageData: [MessageData] {
        var messages: [MessageData] = []

        messages.append(CAIResponseMessageData(text: "I like to play with carousels", false))
        var carouselArr = [CAIResponseMessageData]()
        var iButtons = [
            UIModelDataAction("carousel b1", "carousel b1", .text)
        ]
        let c1 = CAIResponseMessageData("Test1", "Test1 desc", "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/2019-mustang-shelby-gt350-101-1528733363.jpg?crop=0.817xw:1.00xh;0.149xw,0&resize=640:*", nil, iButtons, nil, nil, nil, nil, true)

        carouselArr.append(c1)
        iButtons = [
            UIModelDataAction("carousel button button button button 2", "carousel button button button button 2 ", .text)
        ]
        let c2 = CAIResponseMessageData("Test2", "Test2 desc Test2 desc Test2 desc desc desc desc", "https://thelabradorclub.com/wp-content/uploads/2016/09/purpose-bg.jpg", nil, iButtons, nil, nil, nil, nil, true)

        carouselArr.append(c2)

        let c3 = CAIResponseMessageData("Test3", "Test3 desc desc desc desc desc", nil, nil, iButtons, nil, nil, nil, nil, true)

        carouselArr.append(c3)

        let c4 = CAIResponseMessageData("Test4", "Test4 desc Test4 desc Test4 desc Test4 desc really long desc", nil, nil, iButtons, nil, nil, nil, nil, true)

        carouselArr.append(c4)

        messages.append(CAIResponseMessageData(carouselArr.map { $0.attachment.content! }, true))

        return messages
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
