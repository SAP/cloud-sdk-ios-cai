import SwiftUI

struct BotTextView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let value: NSAttributedString
        
    let isMarkdown: Bool
    
    let geometry: GeometryProxy

    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    private var markdownSize: CGSize {
        let fixedWidth: CGFloat = self.hSizeClass == .regular ? min(480, self.geometry.size.width) : self.geometry.size.width * 0.8
        let tv = UITextView()
        tv.attributedText = self.value
        let newSize = tv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize
    }
    
    private var avatarUrl: String? {
        self.themeManager.value(for: .avatarUrl) as? String
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if avatarUrl != nil {
                AvatarView(imageUrl: avatarUrl!)
            }
            if isMarkdown {
                MarkdownView(themeManager: themeManager, attributedText: value)
                    .frame(width: markdownSize.width, height: markdownSize.height, alignment: .leading)
                    .background(roundedBackground(for: themeManager.theme, key: .incomingBubbleColor))
                    .tail(self.themeManager, reversed: true)
            } else {
                Text(value.string)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .font(.body)
                    .foregroundColor(themeManager.color(for: .incomingTextColor))
                    .padding(themeManager.value(for: .incomingTextContainerInset,
                                                type: EdgeInsets.self,
                                                defaultValue: .all10))
                    .background(roundedBackground(for: themeManager.theme, key: .incomingBubbleColor))
                    .tail(self.themeManager, reversed: true)
            }
        }
    }
}

#if DEBUG
    struct BotTextView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                BotTextView(value: NSAttributedString(string: "hello"), isMarkdown: false, geometry: geometry).environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
