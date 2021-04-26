import SwiftUI

/// TextMessageView is used for regular text and markdown text as well as for any
/// sender.
/// Markdown text will *only* be rendered for Bot text messages, not user.
struct TextMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let model: MessageData
    
    let geometry: GeometryProxy
    
    var value: NSAttributedString? {
        if case .text(let text) = self.model.type {
            return NSAttributedString(string: text)
        }
        if case .attributedText(let text) = self.model.type {
            return text
        }
        assertionFailure("only use `TextMessageView` with message type `text` or `attributedText`")
        return nil
    }
    
    var isMarkdown: Bool {
        if case .attributedText = self.model.type {
            return true
        }
        return false
    }
    
    var body: some View {
        Group {
            if model.sender.isBot {
                BotTextView(value: value!, isMarkdown: isMarkdown, geometry: geometry)
            } else {
                HStack(alignment: .bottom) {
                    Text(value!.string)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .font(.body)
                        .foregroundColor(themeManager.color(for: .outgoingTextColor))
                        .padding(
                            themeManager.value(for: .outgoingTextContainerInset,
                                               type: EdgeInsets.self,
                                               defaultValue: .all10)
                        )
                        .background(roundedBackground(for: self.themeManager.theme, key: .outgoingBubbleColor))
                        .tail(self.themeManager)
                }
            }
        }
    }
}

#if DEBUG
    struct TextMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                TextMessageView(model: testData.model[0], geometry: geometry).environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
