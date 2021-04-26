import SwiftUI

struct QuickRepliesMessageView: View {
    let model: MessageData
    
    let geometry: GeometryProxy
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    var buttons: ButtonsMessageData? {
        if case .quickReplies(let data) = self.model.type {
            return data
        }
        assertionFailure("only use `QuickRepliesMessageView` with message type `quickReplies`")
        return nil
    }
    
    private var padding: CGFloat {
        self.themeManager.value(for: .containerLTPadding, type: CGFloat.self, defaultValue: 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: vSizeClass == .compact ? 2 : 4) {
            BotTextView(value: NSAttributedString(string: buttons!.buttonText!), isMarkdown: false, geometry: geometry)

            if buttons!.buttonsData != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(self.buttons!.buttonsData!, id: \.id) { button in
                            QuickReplyButtonView(button: button)
                        }
                    }
                    .padding([.top, .bottom], 1)
                    .padding([.leading, .trailing], padding)
                }
                .padding([.leading, .trailing], 0 - padding) // bring the scrollview edge to edge
            }
        }
    }
}

#if DEBUG
    struct QuickRepliesMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                QuickRepliesMessageView(model: testData.model[0], geometry: geometry)
            }
        }
    }
#endif
