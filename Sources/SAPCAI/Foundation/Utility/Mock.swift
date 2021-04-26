import Combine
import Foundation

// :nodoc:
public final class MockPublisher: MessagingPublisher {
    public typealias Output = Result<ResponseMessageData, Error>
    
    public typealias Failure = Never

    private var subscriber: AnySubscriber<Output, Failure>?
    
    public init() {}
        
    deinit {}
    
    public func load() {
        // do nothing
    }

    public func postMessage(text: String) {
        let arr = [CAIResponseMessageData(text: text, false)]
        _ = self.subscriber?.receive(.success(CAIConversationResultData(arr)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let resp = [CAIResponseMessageData(text: "Bot response for question \(text)")]
            _ = self.subscriber?.receive(.success(CAIConversationResultData(resp)))
        }
    }
    
    public func postMessage(type: PostbackType, postbackData: PostbackData) {
        let arr = [CAIResponseMessageData(text: postbackData.title, false)]
        _ = self.subscriber?.receive(.success(CAIConversationResultData(arr)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let resp = [CAIResponseMessageData(text: "Bot response for question \(postbackData.title)")]
            _ = self.subscriber?.receive(.success(CAIConversationResultData(resp)))
        }
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, MockPublisher.Failure == S.Failure, MockPublisher.Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
    }
}
