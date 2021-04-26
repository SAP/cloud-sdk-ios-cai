import SwiftUI

struct MultiButtonsView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State var showButtonsActionSheet = false
    
    var buttons: [PostbackData]
    
    private var buttonsArr: [PostbackData] {
        if self.buttons.count > 3 {
            return Array(self.buttons[0 ... 2])
        }
        return self.buttons
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.showButtonsActionSheet = true
            }) {
                Image(systemName: "ellipsis").frame(minWidth: 15, minHeight: 18)
            }
            .buttonStyle(self.themeManager.value(for: .quickReplyButtonStyle,
                                                 type: BaseQuickReplyButtonStyle.self,
                                                 defaultValue: BaseQuickReplyButtonStyle()))
        }
        .actionSheet(isPresented: self.$showButtonsActionSheet) { () -> ActionSheet in
            var iButtons: [Alert.Button] = self.buttonsArr.map { btn in
                .default(Text(btn.title), action: {
                    if btn.dataType == .link {
                        self.viewModel.urlOpenerData.url = btn.value
                        URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: btn.value)
                    } else {
                        self.viewModel.postMessage(type: .button, postbackData: btn)
                    }
                })
            }
            iButtons.append(.destructive(Text("Cancel")))
            return ActionSheet(title: Text("Actions"), message: nil, buttons: iButtons)
        }
    }
}

#if DEBUG
    struct MultiButtonsView_Previews: PreviewProvider {
        static var previews: some View {
            MultiButtonsView(buttons: [UIModelDataAction("Button 1", "Button1", .link)]).environmentObject(ThemeManager.shared)
        }
    }
#endif
