import Foundation
import WebKit

/// Fallback Video Player
/// Takes the URL and loads it into a webView
class DefaultVideoPlayer: VideoPlayable {
    private var webView: WKWebView!
    
    // MARK: Various methods for initialization
    
    init() {
        self.configureWebView()
    }
    
    // MARK: Web view initialization
    
    fileprivate func configureWebView() {
        self.webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.allowsBackForwardNavigationGestures = false
        self.webView.scrollView.isScrollEnabled = false
    }
    
    // MARK: - VideoPlayable

    func loadVideo(url: URL) -> UIView? {
        if let videoID = videoIDFromSAPVideoURL(url) {
            return self.loadVideo(id: videoID)
        }
        return nil
    }
    
    func loadVideo(id: String) -> UIView {
        let url = URL(string: "https://video.sap.com/embed/secure/iframe/entryId/\(id)")!
        return self.loadWebView(url: url)
    }
    
    private func loadWebView(url: URL) -> UIView {
        let request = URLRequest(url: url)
        self.webView.load(request)
        
        return self.webView
    }
    
    static func canRead(url: URL) -> Bool {
        false
//        let sURL = url.absoluteString
//        return sURL.contains("video.sap.com")
    }

    private func videoIDFromSAPVideoURL(_ videoURL: URL) -> String? {
        let components = videoURL.pathComponents
        
        if components.contains("embed") {
            return videoURL.pathComponents.last
        } else if components.contains("media") {
            if let idx = components.firstIndex(of: "media"),
               components.count > idx + 2
            {
                return components[idx + 2]
            }
        }
        return nil
    }
}
