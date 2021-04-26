import SwiftUI

/// UIViewRepresentable. UITextView wrapper.
struct TextView: UIViewRepresentable {
    /// :nodoc:
    typealias UIViewType = UITextView

    var placeholder: String

    @Binding var text: String

    @Binding var textViewHeight: CGFloat
    
    private var initialHeight: CGFloat
    
    var onCommit: () -> Void
        
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Constructor
    /// - Parameter placeholder: String
    /// - Parameter text: Binding
    /// - Parameter textViewHeight: CGFloat
    /// - Parameter onCommit: Handler function called when user presses enter or return
    init(_ placeholder: String, text: Binding<String>, textViewHeight: Binding<CGFloat>, onCommit: @escaping () -> Void = {}) {
        self._text = text
        self.placeholder = placeholder
        
        self.onCommit = onCommit
        
        self._textViewHeight = textViewHeight
        self.initialHeight = textViewHeight.wrappedValue
    }
    
    /// :nodoc:
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// :nodoc:
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView()
        
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        switch self.themeManager.theme {
        case .default:
            textView.layer.cornerRadius = self.initialHeight / 2
        default:
            textView.layer.cornerRadius = 8
        }
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.label
        textView.placeholderColor = UIColor.tertiaryLabel

        textView.placeholderText = self.placeholder

        textView.delegate = context.coordinator

        // TODO: set this from outside
        var inset = textView.textContainerInset
        inset.right += 32 // send button
        inset.left = 6
        textView.textContainerInset = inset
        
        return textView
    }

    /// :nodoc:
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        uiView.text = self.text
        
        if uiView.text.isEmpty {
            uiView.togglePlaceholder()
        }
    }

    /// :nodoc:
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Handle cases when return key is pressed
            if text == "\n" {
                self.parent.text = textView.text
                self.parent.textViewHeight = self.parent.initialHeight
                self.parent.onCommit()
                return false
            }

            self.updateTextViewHeightIfNeeded(textView)
            
            return true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            self.parent.textViewHeight = self.parent.initialHeight
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        private func updateTextViewHeightIfNeeded(_ textView: UITextView) {
            // substract some width to avoid the problem that textView does get fully resized when new line's first character was typed
            let sizeThatFits = textView.sizeThatFits(CGSize(width: textView.frame.size.width - 6, height: textView.frame.size.height))
            
            let newHeight = min(150, max(parent.initialHeight, sizeThatFits.height))
            if newHeight != self.parent.textViewHeight {
                // call frame update
                self.parent.textViewHeight = newHeight
            }
        }
    }
}
