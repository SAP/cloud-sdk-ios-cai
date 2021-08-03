import SwiftUI

struct ButtonView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var button: PostbackData
    var type: PostbackType
    var buttonViewType: ButtonViewType = .cardButton

    enum ButtonViewType {
        case cardButton
        case menuSelectionButton
        case quickReply
    }

    var body: some View {
        Button(action: {
            if self.button.dataType == .link {
                // link navigation feature code
                self.viewModel.urlOpenerData.url = self.button.value
                URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: self.button.value)
            } else if self.button.dataType == .phoneNumber {
                // link navigation feature code
                self.viewModel.urlOpenerData.url = optimizePrefix(for: button.value)
                URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: self.viewModel.urlOpenerData.url)
            } else {
                self.viewModel.postMessage(type: self.type, postbackData: self.button)
            }
        }, label: {
            if self.buttonViewType == .menuSelectionButton {
                HStack {
                    Text(button.title)
                        .font(.body)
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    Spacer()
                }
            } else if self.buttonViewType == .quickReply {
                Text(button.title)
            } else {
                HStack {
                    Spacer()
                    Text(button.title)
                        .font(.body)
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    Spacer()
                }
            }
        })
    }
    
    func optimizePrefix(for phoneNumber: String) -> String {
        if phoneNumber.lowercased().hasPrefix("tel:") {
            return phoneNumber
        } else {
            return "tel:" + phoneNumber
        }
    }
}

#if DEBUG
    struct ButtonView_Previews: PreviewProvider {
        static var previews: some View {
            let button = UIModelDataAction("Button1", "Button1", .link)
        
            return ButtonView(button: button, type: PostbackType.button)
        }
    }
#endif
