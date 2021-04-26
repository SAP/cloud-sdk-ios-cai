import Combine

/// A MessagingPublisher is a Combine that takes care of responding to user-trigerred events and publish streams of responses.
/// The `MessagingViewModel` class relies on this publisher to get the stream of new messages available for the UI. This publisher nevers
/// fails and emits Array of `MessageData`
public protocol MessagingPublisher: Publisher where Output == Result<ResponseMessageData, Error>, Failure == Never {
    /// Tells the publisher to post a message.
    /// - Parameter text: String
    func postMessage(text: String)
    
    /// Tells the publisher to post a message
    /// - Parameter type: PostbackType.
    /// - Parameter postbackData: PostbackData.
    func postMessage(type: PostbackType, postbackData: PostbackData)
    
    /// Tells the publisher that the view is loaded and it's ready to perform any initialization (e.g. fetching data, ...)
    func load()
}
