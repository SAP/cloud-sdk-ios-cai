import SafariServices
import UIKit

/// UIViewController wrapper for SFSafariViewController to allow dynamic URL.
///
/// Unlike SFSafariViewController, once instantiated, you can dynamically set a
/// new URL at runtime.
///
/// Example:
/// ```
/// let controller = SafariViewController()
/// controller.url = URL(string: <#url#>)!
/// ```
class SafariViewController: UIViewController {
    var url: URL? {
        didSet {
            // when url changes, reset the safari view controller
            self.loadSafariViewController()
        }
    }

    private var safariViewController: SFSafariViewController?

    /// :nodoc"
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.loadSafariViewController()
    }

    private func loadSafariViewController() {
        // Remove the previous safari view controller if not nil
        if let sf = safariViewController {
            sf.willMove(toParent: self)
            sf.view.removeFromSuperview()
            sf.removeFromParent()
            self.safariViewController = nil
        }

        guard let url = url else { return }

        // Create a new safari view controller with the url and add as child view
        let newSf = SFSafariViewController(url: url)
        addChild(newSf)
        newSf.view.frame = view.frame
        view.addSubview(newSf.view)
        newSf.didMove(toParent: self)
        self.safariViewController = newSf
    }
}
