import Combine
import Foundation

/// Internal class
final class CreateConversationPublisher: Publisher {
    typealias Output = String
    typealias Failure = CAIError

    private weak var conversation: CAIConversation?
    private var operationQueue: OperationQueue
    
    private var subscribers = [AnySubscriber<Output, Failure>]()
    
    private var operation: Operation?
    
    init(_ conversation: CAIConversation, _ operationQueue: OperationQueue) {
        self.conversation = conversation
        self.operationQueue = operationQueue
    }
    
    deinit {
        dlog("CreateConversationPublisher deinit")
    }
    
    // MARK: Publisher impl
    
    func receive<S>(subscriber: S) where S: Subscriber, CreateConversationPublisher.Failure == S.Failure, CreateConversationPublisher.Output == S.Input {
        guard let conversation = conversation else {
            fatalError("no conversation were created")
        }

        dlog("CreateConversationPublisher receive subscriber")
        
        if let id = conversation.conversationID {
            _ = subscriber.receive(id)
            subscriber.receive(completion: .finished)
            return
        }

        self.subscribers.append(AnySubscriber(subscriber))
        
        if self.operation == nil {
            self.operation = self.createOperation(conversation)
            self.operationQueue.addOperation(self.operation!)
        }
    }
    
    // MARK: - Private
    
    private func createOperation(_ conversation: CAIConversation) -> Operation {
        let createRequest = CAICreateConversationRequest(channel: conversation.channelId, token: conversation.channelToken)
        return CAICreateConversationOperation(conversation.serviceConfig, request: createRequest, finishHandler: { [weak self] result in

            guard let self = self else { return }

            // operation finished, set back to nil
            self.operation = nil
            
            switch result {
            case .success(let response):
                guard let results = response.results, let id = results.id else {
                    self.publish(.failure(CAIError.server(reason: "Create conversationID results is nil or no id has been set")))
                    return
                }
              
                self.publish(id: id, .finished)

            case .failure(let error):
                dlog(error)
                self.publish(.failure(.server(error)))
            }
        })
    }
    
    private func publish(id: String? = nil, _ result: Subscribers.Completion<Failure>) {
        if let id = id {
            dlog("publishing newly created conversationID \(id)")
                            
            self.conversation?.updateConversationId(id)
        }
        
        // emit event to all subscribers, then remove them
        self.subscribers.forEach { s in
            
            if let id = id {
                _ = s.receive(id)
            }
            s.receive(completion: result)
        }
        self.subscribers.removeAll()
    }
}
