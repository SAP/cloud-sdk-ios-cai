import Combine
import Foundation

/// Protocol used by your MessagingPublisher to get messages from the backend.
public protocol MessageDelivering {
    /// Channel ID (read-only)
    var channelId: String { get }

    /// If you need to keep track of the last message id that was returned.
    var lastMessageId: String? { get set }

    /// Callback handler to call when new messages are available
    var onMessages: ((Result<CAIConversationResultData, CAIError>) -> Void)? { get set }

    /// Called by the MessagingPublisher when conversationId has been created
    /// - Parameter conversationId: String
    func initialize(_ conversationId: String)

    /// Called when framework is requesting new messages
    func start()

    /// Called when framework is no longer requesting new messages
    func stop()

    /// Called to ensure the connection is opened before posting a message to the backend
    func reconnect() -> AnyPublisher<Bool, CAIError>
}
