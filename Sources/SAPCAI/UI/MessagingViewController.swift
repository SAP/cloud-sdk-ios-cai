import SwiftUI
import UIKit

public typealias MessagingView = ModifiedContent<ModifiedContent<AssistantView, _EnvironmentKeyWritingModifier<MessagingViewModel?>>, _EnvironmentKeyWritingModifier<ThemeManager?>>

/// This class is meant to be used by UIKit like a standard UIViewController. It will host the SwiftUI `AssistantView` with default parameters.
/// > Do not use this class if you are using SwiftUI in your project, it is recommended to directly work with AssistantView.
/// > Do not use with Storyboards.
///
///  ```
/// let publisher = <#some MessagingPublisher#>
/// let vc = MessagingViewController(MessagingViewModel(publisher: publisher))
/// self.navigationController?.pushViewController(vc, animated: true)
/// ```
///
open class MessagingViewController: UIHostingController<MessagingView> {
    /// Constructor
    /// - Parameter viewModel: MessagingViewModel
    /// - Parameter theme: CAITheme. Default is Fiori with Fiori colors
    public convenience init(_ viewModel: MessagingViewModel, theme: CAITheme = .fiori(FioriColorPalette())) {
        ThemeManager.shared.setCurrentTheme(theme)
        
        // swiftlint:disable:next force_cast
        self.init(rootView: AssistantView().environmentObject(viewModel).environmentObject(ThemeManager.shared) as! MessagingView)
    }
    
    // The `InputBarAccessoryView` used as the `inputAccessoryView` in the view controller.
    /// :nodoc:
    open var messageInputBar = UIView()
    
    // MARK: - Overrides read-only properties
    
//    open override var canBecomeFirstResponder: Bool {
//        return true
//    }
    
    // overrides default inputAccessoryView with `messageInputBar`
//    open override var inputAccessoryView: UIView? {
//        return messageInputBar
//    }
    
    /// :nodoc:
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
}
