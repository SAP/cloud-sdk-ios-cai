import SwiftUI

struct MessageView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @EnvironmentObject private var themeManager: ThemeManager

    let model: MessageData

    let geometry: GeometryProxy
    
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
//    @State private var isActive = false
    
    var body: some View {
        // leading, trailing or center should not matter: this stack should be full width
        VStack(spacing: 0) {
            if self.model.isText {
                // maxWidth set to 80% of the available space
                TextMessageView(model: self.model, geometry: geometry)
                    .textWidth(geometry, isRegular: hSizeClass == .regular, isBot: model.sender.isBot)
//                    .alert(isPresented: self.$showSenderInfo) {
//                        Alert(title: Text("Sender Info"), message: Text("..."))
//                    }
            } else if self.model.isPicture {
                ImageMessageView(model: self.model, geometry: geometry)
            } else if self.model.isVideo {
                VideoMessageView(model: self.model, geometry: geometry)
                    .background(roundedBorder(for: self.themeManager.theme))
            } else if self.model.isObject {
                ObjectCardMessageView(model: self.model.getObject!)
                    .background(roundedBorder(for: self.themeManager.theme))
            } else if self.model.isList {
                ListMessageView(model: self.model)
                    .background(roundedBorder(for: self.themeManager.theme))
            } else if self.model.isButtons {
                ButtonsMessageView(model: self.model, geometry: geometry)
                    .environmentObject(self.viewModel)
            } else if self.model.isQuickReplies {
                QuickRepliesMessageView(model: self.model, geometry: geometry)
            } else if self.model.isCarousel {
                CarouselMessageView(model: self.model, geometry: geometry)
            } else if self.model.customView != nil {
                self.model.customView!.view
            } else if self.model.isUnknown {
                UnknownMessageView(model: self.model)
            }
            // TODO:
            // - add form mesage view
            else {
                Spacer()
            }
            
            // bottom hstack container
            // display actions
            // CURRENTLT NOT USED
//            if self.model.buttons != nil {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack (alignment: .center, spacing: 10) {
//                        ForEach(self.model.buttons!, id: \.id) { button in
//                            QuickReplyButtonView(button: button)
//                        }
//                    }
//                }
//            }
        }
    }
}

#if DEBUG
    struct MessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                MessageView(model: testData.model[0], geometry: geometry).environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
