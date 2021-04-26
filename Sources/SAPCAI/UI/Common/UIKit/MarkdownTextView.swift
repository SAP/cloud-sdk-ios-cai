import Foundation
import UIKit

class MarkdownTextView: UIView {
    let textView: UITextView
    
    var attributedText: NSAttributedString {
        didSet {
            self.textView.attributedText = self.attributedText
        }
    }
    
    init(frame: CGRect, attributedText: NSAttributedString) {
        self.textView = UITextView(frame: CGRect(origin: .zero, size: frame.size), textContainer: nil)
        self.attributedText = attributedText
        self.textView.attributedText = attributedText
        
        super.init(frame: frame)
        
        self.textView.delegate = self
        self.textView.isEditable = false
        self.textView.isScrollEnabled = false
        self.textView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(self.textView)

        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.topAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MarkdownTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
