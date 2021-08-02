import Combine
import Foundation

struct AnyMessagingPublisher<Output, Failure> where Failure: Error {
    @usableFromInline internal let box: PublisherBoxBase<Output, Failure>

    @inlinable
    init<P>(_ publisher: P) where Output == P.Output, Failure == P.Failure, P: MessagingPublisher {
        self.box = PublisherBox(base: publisher)
    }

    func postMessage(text: String, memoryOptions: MemoryOptions? = nil) {
        self.box.postMessage(text: text, memoryOptions: memoryOptions)
    }

    func postMessage(type: PostbackType, postbackData: PostbackData, memoryOptions: MemoryOptions? = nil) {
        self.box.postMessage(type: type, postbackData: postbackData, memoryOptions: memoryOptions)
    }

    func load() {
        self.box.load()
    }
}

/// A type-erasing base class. Its concrete subclass is generic over the underlying
/// publisher.
@usableFromInline
class PublisherBoxBase<Output, Failure: Error>: Publisher {
    internal init() {}

    @inlinable
    internal func receive<SubscriberType: Subscriber>(subscriber: SubscriberType)
        where Failure == SubscriberType.Failure, Output == SubscriberType.Input
    {
        fatalError("required function to be overridden")
    }

    func postMessage(text: String, memoryOptions: MemoryOptions? = nil) {
        fatalError("required function to be overridden")
    }

    func postMessage(type: PostbackType, postbackData: PostbackData, memoryOptions: MemoryOptions? = nil) {
        fatalError("required function to be overridden")
    }

    func load() {
        fatalError("required function to be overridden")
    }
}

@usableFromInline
final class PublisherBox<PublisherType: MessagingPublisher>: PublisherBoxBase<PublisherType.Output, PublisherType.Failure> {
    @usableFromInline internal let base: PublisherType

    internal init(base: PublisherType) {
        self.base = base
        super.init()
    }

    @inlinable
    override internal func receive<SubscriberType: Subscriber>(subscriber: SubscriberType)
        where Failure == SubscriberType.Failure, Output == SubscriberType.Input
    {
        self.base.subscribe(subscriber)
    }

    override func postMessage(text: String, memoryOptions: MemoryOptions? = nil) {
        self.base.postMessage(text: text, memoryOptions: memoryOptions)
    }

    override func postMessage(type: PostbackType, postbackData: PostbackData, memoryOptions: MemoryOptions? = nil) {
        self.base.postMessage(type: type, postbackData: postbackData, memoryOptions: memoryOptions)
    }

    override func load() {
        self.base.load()
    }
}
