import UIKit

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView {
    private static let placeholderTag = 100
    
    var placeholderLabel: UILabel? {
        self.viewWithTag(UITextView.placeholderTag) as? UILabel
    }
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    override open var frame: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    var placeholderText: String? {
        get {
            var sPlaceholder: String?
            
            if let placeholderLabel = self.viewWithTag(UITextView.placeholderTag) as? UILabel {
                sPlaceholder = placeholderLabel.text
            }
            
            return sPlaceholder
        }
        set(newValue) {
            if newValue == nil {
                NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
                
                if let placeholderLabel = self.viewWithTag(UITextView.placeholderTag) as? UILabel {
                    placeholderLabel.removeFromSuperview()
                }
            } else {
                if let placeholderLabel = self.viewWithTag(UITextView.placeholderTag) as? UILabel {
                    placeholderLabel.text = newValue
                    placeholderLabel.sizeToFit()
                } else {
                    self.addPlaceholder(newValue!)
                    NotificationCenter.default.addObserver(self, selector: #selector(UITextView.textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
                }
                accessibilityLabel = newValue
            }
        }
    }
    
    var placeholderColor: UIColor? {
        get {
            if let l = placeholderLabel {
                return l.textColor
            }
            return nil
        }
        set {
            if let l = placeholderLabel {
                l.textColor = newValue
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    @objc
    func textDidChange(_ note: Notification) {
        self.togglePlaceholder()
    }
    
    func togglePlaceholder() {
        if let l = placeholderLabel {
            l.isHidden = !self.text.isEmpty
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    fileprivate func resizePlaceholder() {
        if let l = placeholderLabel {
            let fittingSize = self.sizeThatFits(self.frame.size)
            
            let labelHeight = l.frame.height
            let labelX = self.textContainer.lineFragmentPadding + self.textContainerInset.left
            let labelY = ((fittingSize.height - labelHeight) / 2)
            let labelWidth = self.frame.width - (labelX * 2)
            
            l.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.font = self.font?.italic()
        placeholderLabel.textColor = self.placeholderColor ?? UIColor.lightGray

        placeholderLabel.sizeToFit()
        
        placeholderLabel.tag = UITextView.placeholderTag
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        placeholderLabel.isAccessibilityElement = false
        
        self.resizePlaceholder()
        self.addSubview(placeholderLabel)
    }
}

private extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0) // size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        self.withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        self.withTraits(traits: .traitItalic)
    }
}
