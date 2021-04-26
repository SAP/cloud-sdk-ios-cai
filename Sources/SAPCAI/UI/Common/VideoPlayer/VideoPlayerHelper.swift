import Foundation

/// Help class for handling video links
enum VideoPlayerHelper {
    /// Check if URL is a video link and can be read by any of our supported players
    ///
    /// - Parameter url: URL
    /// - Returns: Bool. True if we have a player that supports that URL
    static func canRead(url: URL) -> Bool {
        if DefaultVideoPlayer.canRead(url: url) {
            return true
        }
        if YoutubePlayer.canRead(url: url) {
            return true
        }
        return false
    }
    
    /// Factory function that returns the player for that URL
    ///
    /// - Parameter url: URL
    /// - Returns: VideoPlayable. nil if no player can read that URL
    static func videoPlayer(for url: URL) -> VideoPlayable? {
        if DefaultVideoPlayer.canRead(url: url) {
            return DefaultVideoPlayer()
        }
        if YoutubePlayer.canRead(url: url) {
            return YoutubePlayer()
        }
        return nil
    }
}
