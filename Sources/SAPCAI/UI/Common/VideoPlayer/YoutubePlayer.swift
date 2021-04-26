import Foundation
import WebKit

struct PlayerParameters: Codable {
    var height: String = "100%"
    
    var width: String = "100%"
    
    var events: [String: String] = [
        "onReady": "onReady",
        "onStateChange": "onStateChange",
        "onPlaybackQualityChange": "onPlaybackQualityChange",
        "onError": "onPlayerError"
    ]
    
    var videoId: String?
}

/// Helper class that generates a `WKWebView` for you to load a Youtube video inside.
class YoutubePlayer: VideoPlayable {
    private var webView: WKWebView!
    
    private var playerParameters = PlayerParameters()
    
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
    
    /// Returns true if URL is a link to a Youtube video
    /// - Parameter url: URL
    static func canRead(url: URL) -> Bool {
        let sURL = url.absoluteString
        
        return sURL.contains("youtube.com") || sURL.contains("youtu.be")
    }
    
    /// Loads video from URL
    /// - Parameter url: URL. Link to the Youtube video
    /// - Returns: UIView or nil if URL is not a Youtube link
    func loadVideo(url: URL) -> UIView? {
        if let videoID = videoIDFromYouTubeURL(url) {
            return self.loadVideo(id: videoID)
        }
        return nil
    }
    
    /// Loads video from URL
    /// - Parameter id: String. Youtube video ID.
    func loadVideo(id: String) -> UIView {
        self.playerParameters.videoId = id
        return self.loadWebView()
    }
    
    private func videoIDFromYouTubeURL(_ videoURL: URL) -> String? {
        if videoURL.pathComponents.count > 1, (videoURL.host?.hasSuffix("youtu.be"))! {
            return videoURL.pathComponents[1]
        } else if videoURL.pathComponents.contains("embed") {
            return videoURL.pathComponents.last
        }
        return videoURL.queryStringComponents()["v"] as? String
    }
    
    private func loadWebView() -> UIView {
        if let url = Bundle.cai.url(forResource: "YTPlayer", withExtension: "html"),
           let htmlTemplate = try? String(contentsOf: url)
        {
            if let data = try? JSONEncoder().encode(playerParameters),
               let sData = String(data: data, encoding: .utf8)
            {
                let htmlContent = htmlTemplate.replacingOccurrences(of: "%@", with: sData)
                
                self.webView.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
        
        return self.webView
    }
}

private extension URL {
    func queryStringComponents() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        // Check for query string
        if let query = self.query {
            // Loop through pairings (separated by &)
            for pair in query.components(separatedBy: "&") {
                // Pull key, val from from pair parts (separated by =) and set dict[key] = value
                let components = pair.components(separatedBy: "=")
                if components.count > 1 {
                    dict[components[0]] = components[1] as AnyObject?
                }
            }
        }
        return dict
    }
}
