@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class ProductListTests: AssistantViewTestCase {
    // MARK: - Configuration

    override var configs: [SnapshotTestViewConfig] {
        let configs = PresetViewImageConfigs()
        return configs.phones
    }

    override var messsageData: [MessageData] {
        var messages: [MessageData] = []

        // text message 22 (user)
        messages.append(CAIResponseMessageData(text: "List products", false))

        // list 23
        var headerArr = [CAIResponseMessageData]()
        var iButtons = [
            UIModelDataAction("List b1", "List b1", .text)
        ]
        headerArr.append(CAIResponseMessageData("HP Laptop", "HP Laptop - 15 inch touch screen with Intel i7 processor.", "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962448.png", nil, iButtons, nil, "Available", nil, nil, true))

        iButtons = [
            UIModelDataAction("List postback", "List postback", .postback)
        ]
        var h2 = CAIResponseMessageData("iPhone XR", "iPhone", "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xr/iphone-xr-black-select-201809?wid=470&hei=556&fmt=png-alpha&.v=1551226038992", nil, iButtons, nil, "Out of Stock", nil, nil, true)
        h2.attachment.buttons = iButtons
        headerArr.append(h2)

        let h3 = CAIResponseMessageData("Samsung Galaxy s10", "samsung galaxy", nil, nil, nil, nil, "Available", "In Stock", nil, true)
        headerArr.append(h3)

        iButtons = [
            UIModelDataAction("Link1", "https://www.google.com", .link),
            UIModelDataAction("Link2", "https://www.pinterest.com", .link),
            UIModelDataAction("Phone1", "14081231234", .phoneNumber),
            UIModelDataAction("Phone2", "14081231235", .phoneNumber),
            UIModelDataAction("Phone3", "14081231235", .phoneNumber)
        ]
        let h4 = CAIResponseMessageData("Product4", "Product 4", "https://freeicons.io/laravel/public/uploads/icons/png/12835256891551942291-128.png", nil, iButtons, nil, "Available", nil, nil, true)
        headerArr.append(h4)

        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h5 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h5.attachment.buttons = iButtons
        headerArr.append(h5)

        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h6 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h6.attachment.buttons = iButtons
        headerArr.append(h6)

        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h7 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h7.attachment.buttons = iButtons
        headerArr.append(h7)

        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h8 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h8.attachment.buttons = iButtons
        headerArr.append(h8)

        iButtons = [
            UIModelDataAction("Footer button", "Footer button", .text)
        ]
        messages.append(CAIResponseMessageData(headerArr.map { $0.attachment.content! }, iButtons, "List of Products", "Electronics", "Sample Electronics", false))

        return messages
    }

    // MARK: - Tests

    func testFioriTheme() throws {
        let view = getAssistantView(with: messsageData, theme: CAITheme.fiori(FioriV6ColorPalette()))

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
