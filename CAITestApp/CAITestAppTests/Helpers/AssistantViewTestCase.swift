@testable import CAITestApp
import SAPCAI
import SwiftUI
import XCTest

class AssistantViewTestCase: XCTestCase {
    var configs: [SnapshotTestViewConfig] {
        let configs = PresetViewImageConfigs()
        return configs.phones + configs.pads
    }

    var messsageData: [MessageData] {
        fatalError("Needs to be provided by actual test case")
    }

    func getAssistantView(with messsageData: [MessageData], theme: CAITheme = CAITheme.fiori(FioriColorPalette()), menu: CAIChannelPreferencesMenuData? = nil) -> some View {
        ThemeManager.shared.setCurrentTheme(theme)
        let model = self.getMessagingViewModel(with: messsageData)
        return AssistantView().environmentObject(model).environmentObject(ThemeManager.shared)
    }

    func getMessagingViewModel(with messageData: [MessageData], menu: CAIChannelPreferencesMenuData? = nil) -> MessagingViewModel {
        let vm = MessagingViewModel(publisher: MockPublisher())

        vm.addMessages(contentsOf: messageData)
        vm.menu = menu

        return vm
    }

    func getPreferenceMenu() -> CAIChannelPreferencesMenuData {
        // preferences menu
        let menuAction1 = CAIChannelMenuDataAction("Google", "Link", "https://www.google.com", nil)
        let menuAction2 = CAIChannelMenuDataAction("Postback1", "postback", "This is postback1", nil)
        let menuAction4 = CAIChannelMenuDataAction("SAP", "Link", "https://www.sap.com", nil)
        let menuAction5 = CAIChannelMenuDataAction("Postback2", "postback", "This is postback2", nil)

        let menuAction3_1 = CAIChannelMenuDataAction("Youtube", "Link", "https://www.youtube.com", nil)
        let menuAction3_2 = CAIChannelMenuDataAction("Postback2", "postback", "This is postback2", nil)
        let menuAction3_4 = CAIChannelMenuDataAction("Youtube2", "Link", "https://www.youtube.com", nil)
        let menuAction3_5 = CAIChannelMenuDataAction("Postback3", "postback", "This is postback3", nil)

        let menuAction3_3_1 = CAIChannelMenuDataAction("Youtube2", "Link", "https://www.youtube.com", nil)
        let menuAction3_3_2 = CAIChannelMenuDataAction("Postback3", "postback", "This is postback3", nil)
        let menuAction3_3_3 = CAIChannelMenuDataAction("Youtube4", "Link", "https://www.youtube.com", nil)
        let menuAction3_3_4 = CAIChannelMenuDataAction("Postback5", "postback", "This is postback5", nil)
        var nestedActions2 = [CAIChannelMenuDataAction]()
        nestedActions2.append(menuAction3_3_2)
        nestedActions2.append(menuAction3_3_1)
        nestedActions2.append(menuAction3_3_4)
        nestedActions2.append(menuAction3_3_3)

        let menuAction3_3 = CAIChannelMenuDataAction("Nested2", "nested", nil, nestedActions2)

        var nestedActions = [CAIChannelMenuDataAction]()
        nestedActions.append(menuAction3_3)
        nestedActions.append(menuAction3_1)
        nestedActions.append(menuAction3_2)
        nestedActions.append(menuAction3_5)
        nestedActions.append(menuAction3_4)

        let menuAction3 = CAIChannelMenuDataAction("Nested1", "nested", nil, nestedActions)

        var menuActions = [CAIChannelMenuDataAction]()
        menuActions.append(menuAction2)
        menuActions.append(menuAction3)
        menuActions.append(menuAction1)
        menuActions.append(menuAction5)
        menuActions.append(menuAction4)

        let md = CAIChannelMenuData("en", menuActions)
        let pm = CAIChannelPreferencesMenuData("en", md)

        return pm
    }
}
