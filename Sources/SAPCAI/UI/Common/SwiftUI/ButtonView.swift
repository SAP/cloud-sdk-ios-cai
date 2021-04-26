import SwiftUI

struct ButtonView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var button: PostbackData
    var type: PostbackType
    var buttonViewType: String? = "CardButton"
    var body: some View {
        Button(action: {
            if self.button.dataType == .link {
                // link navigation feature code
                self.viewModel.urlOpenerData.url = self.button.value
                URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: self.button.value)
            } else if self.button.dataType == .phoneNumber {
                // link navigation feature code
                self.viewModel.urlOpenerData.url = "tel:" + self.button.value
                URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: self.viewModel.urlOpenerData.url)
            } else {
                self.viewModel.postMessage(type: self.type, postbackData: self.button)
            }
        }, label: {
            if self.type == .button {
                if self.buttonViewType == "MenuSelectionButton" {
                    HStack {
                        Text(button.title)
                            .font(.body)
                            .lineLimit(1)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        Spacer()
                    }
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
            } else if self.type == .quickReply {
                Text(button.title)
            }
        })
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
