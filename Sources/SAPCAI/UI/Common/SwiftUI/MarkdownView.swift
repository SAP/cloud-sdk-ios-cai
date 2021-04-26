import SwiftUI
import UIKit

struct MarkdownView: UIViewRepresentable {
    let themeManager: ThemeManager
    let attributedText: NSAttributedString
        
    // Creates a `UIView` instance to be presented.
    func makeUIView(context: Self.Context) -> MarkdownTextView {
        let v = MarkdownTextView(frame: .zero, attributedText: attributedText)
        
        var insets = self.themeManager.value(for: .incomingTextContainerInset,
                                             type: EdgeInsets.self,
                                             defaultValue: .all10).toUIEdgeInsets
        insets.left -= v.textView.textContainer.lineFragmentPadding
        insets.right -= v.textView.textContainer.lineFragmentPadding
        v.textView.textContainerInset = insets

        v.backgroundColor = .clear
        v.textView.backgroundColor = UIColor.clear
        
        return v
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: MarkdownTextView, context: Self.Context) {}
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(themeManager: ThemeManager.shared, attributedText: NSAttributedString(string: "Hello"))
    }
}
