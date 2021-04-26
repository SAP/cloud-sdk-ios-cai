import SafariServices
import SwiftUI
import UIKit

/// Safari UI View for loading URL in a browser
struct SafariUIView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SafariViewController
    
    let url: URL

    /// returns SFSafariViewController
    ///
    /// - Parameter context: SafariUIView
    /// - Returns: SFSafariViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariUIView>) -> SafariViewController {
        SafariViewController()
    }

    /// update SFSafariViewController
    func updateUIViewController(_ uiViewController: SafariViewController,
                                context: UIViewControllerRepresentableContext<SafariUIView>)
    {
        uiViewController.url = self.url
    }
}
