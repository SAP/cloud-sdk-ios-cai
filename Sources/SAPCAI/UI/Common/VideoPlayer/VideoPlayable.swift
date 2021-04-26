import Foundation
import UIKit

protocol VideoPlayable {
    static func canRead(url: URL) -> Bool
    
    func loadVideo(url: URL) -> UIView?
}

extension URL {
    /// Checks if URL is a Video link that can be rendered
    ///
    /// - Returns: Bool
    func isReadableVideo() -> Bool {
        VideoPlayerHelper.canRead(url: self)
    }
}
