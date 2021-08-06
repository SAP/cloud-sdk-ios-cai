import SwiftUI

struct QuickRepliesMessageView: View {
    let model: MessageData
    
    let geometry: GeometryProxy
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    @Environment(\.horizontalSizeClass) private var hSizeClass

    private var isPortrait: Bool {
        self.hSizeClass == .compact && self.vSizeClass == .regular
    }
    
    var buttons: ButtonsMessageData? {
        if case .quickReplies(let data) = self.model.type {
            return data
        }
        assertionFailure("only use `QuickRepliesMessageView` with message type `quickReplies`")
        return nil
    }

    var amountOfButtons: Int {
        let limitForVisibleButtons = 11
        guard let amountOfButtons = buttons?.buttonsData?.count else { return 0 }
        return (amountOfButtons >= limitForVisibleButtons) ? limitForVisibleButtons : amountOfButtons
    }
    
    private var padding: CGFloat {
        self.themeManager.value(for: .containerLTPadding, type: CGFloat.self, defaultValue: 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: vSizeClass == .compact ? 2 : 4) {
            BotTextView(value: NSAttributedString(string: buttons?.buttonText ?? ""), isMarkdown: false, geometry: geometry)

            if let buttons = buttons, let buttonsData = buttons.buttonsData {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(0 ..< amountOfButtons) { i in
                            QuickReplyButtonView(button: buttonsData[i])
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
            Group {
                QuickRepliesMessageView_Previews.quickReplyPreview
                    .previewLayout(.sizeThatFits)
                QuickRepliesMessageView_Previews.quickReplyPreview
                    .previewLayout(.fixed(width: 1000, height: 300))
            }
        }
    
        static var quickReplyPreview: some View {
            GeometryReader { geometry in
                QuickRepliesMessageView(model: PreviewData.quickReply.model[0], geometry: geometry)
                    .environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
