import SwiftUI
import UIKit

/// SwiftUI  UIViewRepresentable to render a Video.
/// > Currently only supporting Youtube links
final class VideoView: UIViewRepresentable {
    var mediaURL: String?
    
    /// Creates a `UIView` instance to be presented.
    func makeUIView(context: Context) -> UIView {
        guard let t = mediaURL, let url = t.extractURL() else {
            return UIView() // return broken view
        }
        guard let player = VideoPlayerHelper.videoPlayer(for: url) else {
            return UIView() // return broken view
        }
        return player.loadVideo(url: url) ?? UIView()
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: UIView, context: Context) {}

    init(_ videoURL: String?) {
        self.mediaURL = videoURL
    }
}
