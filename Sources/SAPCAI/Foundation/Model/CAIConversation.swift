import Combine
import Foundation
import SAPCommon
import SAPFoundation

/// This class is the standard implementation of `MessagingPublisher` for connecting
/// to a bot of the CAI platform via the Channel Connector.
///
public final class CAIConversation: MessagingPublisher {
    public typealias Output = Result<ResponseMessageData, Error>
    public typealias Failure = Never
    
    // Optional here but mandatory to make a request. Should only be set using `setConversationId(_:)`
    /// CAI Conversation ID.
    /// Read-only getter to get the current conersation ID set with this object.
    /// It's created for you in `load()` or you can pass it in constructor
    public private(set) var conversationID: String?
            
    // MARK: - Internal properties
    
    /// CAI Backend Service configuration
    var serviceConfig: CAIServiceConfig { didSet { self.resetConversation() } }
        
    /// Channel ID
    var channelId: String { didSet { self.resetConversation() } }
    
    /// Channel connector token sent in request header X-REQUEST-TOKEN
    var channelToken: String? { didSet { self.resetConversation() } }
            
    // MARK: - Private properties
    
    private var messageDeliveryService: MessageDelivering
    
    /// Operation Queue to make sure only one server request is processed at the same time for one conversation
    private var operationQueue: OperationQueue = {
        let ret = OperationQueue()
        ret.maxConcurrentOperationCount = 5
        ret.qualityOfService = .userInteractive
        return ret
    }()
        
    // subscriber that subscribes to this publish to get new messages
    private var subscriber: AnySubscriber<Output, Never>?
    
    private let logger = Logger.shared(named: "CAIFoundation.CAIConversation")
    
    private var createConversionPublisher: AnyPublisher<String, CAIError>?
        
    // private let channelService: CAIChannelService
    
    private var isLoaded = false
    
    // MARK: - Lifecycle
    
    /// Creates a new conversation object
    /// - Parameters:
    ///   - config: The configuration object holding central config properties
    ///   - channelId: The channel ID (from channel connector)
    ///   - channelToken: The channel connector token (mandatory for communication with CAI; can be added as custom header in Mobile Services)
    ///   - messageDelivery: Method / UI Protocol on how to retrieve messages from backend. Polling & WebSocket are supported.
    ///   - conversationID: An existing conversation ID (stored somewhere externally).
    ///                             If this is supplied, no new conversation will be created in the backend.
    ///                             Optional.
    ///                             Default is nil hence a request to the backend will be triggered to create one.
    private init(config: CAIServiceConfig, channelId: String, channelToken: String?, messageDelivery: MessageDelivering, withExistingConvID conversationID: String? = nil) {
        self.channelId = channelId
        self.channelToken = channelToken
        self.serviceConfig = config
                
        self.conversationID = conversationID

        self.messageDeliveryService = messageDelivery
        self.messageDeliveryService.onMessages = { [weak self] result in
            self?.publish(result)
        }
    }
    
    /// Creates a new CAI conversation object.
    /// - Parameter config: The configuration object holding central config properties
    /// - Parameter channelId: The channel ID (from channel connector)
    /// - Parameter channelToken: The channel connector token
    /// - Parameter conversationID: An existing conversation ID (stored somewhere externally).
    ///                             If this is supplied, no new conversation will be created in the backend.
    ///                             Optional.
    ///                             Default is nil hence a request to the backend will be triggered to create one.
    public convenience init(config: CAIServiceConfig, channelId: String, channelToken: String?, withExistingConvID conversationID: String? = nil) {
        let delivery = PollMessageDelivery(channelToken: channelToken, channelId: channelId, serviceConfig: config)
        
        self.init(config: config, channelId: channelId, channelToken: channelToken, messageDelivery: delivery, withExistingConvID: conversationID)
    }
    
    /// Creates a new CAI conversation object. Convenience init using CAIChannel struct
    /// - Parameter config: CAIServiceConfig
    /// - Parameter channel: CAIChannel. Channel you want to create a conversation to
    /// - Parameter conversationID: An existing conversation ID (stored somewhere externally).
    ///                             If this is supplied, no new conversation will be created in the backend.
    ///                             Optional.
    ///                             Default is nil hence a request to the backend will be triggered to create one.
    public convenience init(config: CAIServiceConfig, channel: CAIChannel, withExistingConvID conversationID: String? = nil) {
        self.init(config: config, channelId: channel.id, channelToken: channel.token, withExistingConvID: conversationID)
    }
    
    /// Creates a new CAI conversation object. Convenience init using CAIChannel struct
    /// - Parameters:
    ///   - config: CAIServiceConfig
    ///   - channel: CAIChannel. Channel you want to create a conversation to
    ///   - messageDelivery: Method / UI Protocol on how to retrieve messages from backend. Polling & WebSocket are supported.
    ///   - conversationID: An existing conversation ID (stored somewhere externally).
    ///                             If this is supplied, no new conversation will be created in the backend.
    ///                             Optional.
    ///                             Default is nil hence a request to the backend will be triggered to create one.
    public convenience init(config: CAIServiceConfig, channel: CAIChannel, messageDelivery: MessageDelivering, withExistingConvID conversationID: String? = nil) {
        self.init(config: config, channelId: channel.id, channelToken: channel.token, messageDelivery: messageDelivery, withExistingConvID: conversationID)
    }
    
    deinit {
        dlog("CAIConversation deinit")
    }
    
    // MARK: - Public API
    
    public func load() {
        guard !self.isLoaded else { return }
        
        self.isLoaded = true
        
        if let id = conversationID {
            self.messageDeliveryService.initialize(id)
            
            if self.messageDeliveryService.lastMessageId == nil {
                // load existing messages
                self.loadConversation(id) { [weak self] result in
                    self?.publish(result.map { $0.results! })
                }
            }
        } else {
            self.createConversationId()
        }
    }
    
    /// Reset an existing conversation. Next time a message is sent, this will trigger a creation of a new conversation.
    public func resetConversation() {
        self.messageDeliveryService.stop()

        self.createConversionPublisher = nil
        self.conversationID = nil
    }
    
    /// Reset an existing conversation and create a new conversation.
    public func resetAndCreateConversation() {
        self.resetConversation()
        self.createConversationId()
        self.messageDeliveryService.lastMessageId = nil
        self.isLoaded = false
        self.load()
    }

    /// Post a text message to CAI platform
    /// - Parameter text: String
    public func postMessage(text: String, memoryOptions: MemoryOptions? = nil) {
        let attachmentData = CAITextAttachmentData(text)
        postMessage(attachmentData, memoryOptions: memoryOptions)
    }
    
    /// Post a postback action to CAI platform. Used by buttons and quickReplies
    /// - Parameter type: UIModelPostbackRequestDataType
    /// - Parameter postbackData: ButtonData
    public func postMessage(type: PostbackType, postbackData: PostbackData, memoryOptions: MemoryOptions? = nil) {
        let attachmentData = CAIPostbackAttachmentData(type, postbackData)
        postMessage(attachmentData, memoryOptions: memoryOptions)
    }
    
    /// Creates a conversation in the backend and returns the newly created conversation ID
    /// - Parameter completionHandler: Handler function
    public func createConversation(_ completionHandler: @escaping ((Result<String, CAIError>) -> Void)) {
        let createRequest = CAICreateConversationRequest(channel: self.channelId, token: self.channelToken)
        self.operationQueue.addOperation(CAICreateConversationOperation(self.serviceConfig, request: createRequest, finishHandler: { result in

            switch result {
            case .success(let response):
                guard let results = response.results, let id = results.id else {
                    completionHandler(.failure(CAIError.server(nil, reason: "Create conversationID results is nil or no id has been set")))
                    return
                }
                completionHandler(.success(id))

            case .failure(let error):
                completionHandler(.failure(CAIError.server(error)))
            }
        }))
    }
    
    /// Returns a publisher that emits the current conversationId. If no conversationId is available, it will trigger a backend call to
    /// create a new one.
    public func getConversationId() -> AnyPublisher<String, CAIError> {
        if self.createConversionPublisher == nil {
            self.createConversionPublisher = CreateConversationPublisher(self, self.operationQueue).eraseToAnyPublisher()
        }
        return self.createConversionPublisher!
    }
    
    /// Loads content for an existing conversation ID
    /// - Parameter conversationId: String
    /// - Parameter completionHandler: Handler function called once finished
    public func loadConversation(_ conversationId: String, _ completionHandler: @escaping (Result<CAIResponseData, CAIError>) -> Void) {
        let loadRequest = CAILoadConversationRequest(channelId: channelId, channelToken: channelToken, conversationId: conversationId, lastMessageId: nil)
        operationQueue.addOperation(CAILoadConversationOperation(self.serviceConfig, request: loadRequest, finishHandler: { result in
            completionHandler(result)
        }))
    }
    
    // MARK: - Publisher impl
    
    public func receive<S>(subscriber: S) where S: Subscriber, CAIConversation.Failure == S.Failure, CAIConversation.Output == S.Input {
        self.logger.debug("subscribing \(subscriber)")
        
        self.subscriber = AnySubscriber(subscriber)
    }
        
    /// Finishes the initialization of the CAIConversation object once the conversation ID is available.
    func updateConversationId(_ id: String) {
        if self.conversationID != nil {
            self.resetConversation()
        }
        
        self.conversationID = id
        
        self.messageDeliveryService.initialize(id)
    }
        
    // MARK: Private functions
    
    private func createConversationId() {
        self.logger.debug("create conv id")
        _ = self.getConversationId()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    self.publish(.failure(err))
                }
            }, receiveValue: { _ in
            })
    }

    private func postMessage<T: CAIAttachmentData>(_ input: T, memoryOptions: MemoryOptions? = nil) {
        // publish question so it is rendered in the UI right away
        // for now we will wait for the server to push it back
        // publish( .success( CAIConversationResultData( [ CAIResponseMessageData(text: input.text, false) ] ) ) )
        
        _ = self.getConversationId()
            .flatMap { _ -> AnyPublisher<Bool, CAIError> in
                self.messageDeliveryService.reconnect()
            }
            .tryMap { _ -> CAIPostMessageRequest in
                try CAIPostMessageRequest(input,
                                          channelId: self.channelId,
                                          token: self.channelToken,
                                          conversationId: self.conversationID!,
                                          memoryOptions: memoryOptions)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.logger.error("\(error)")
                case .finished:
                    self.logger.debug("conversationID successfully created and WebSocket connected")
                }

            }, receiveValue: { request in
                
                self.logger.debug("Posting message with input: \(input)")

                self.operationQueue.addOperation(CAIPostMessageOperation(self.serviceConfig, request: request, finishHandler: { [weak self] result in
                                        
                    switch result {
                    case .success:
                        self?.logger.debug("CAIPostMessageOperation finished \(result)")
                        self?.messageDeliveryService.start()
                    case .failure(let error):
                        self?.logger.error("CAIPostMessageOperation finished with Error \(error)")
                        self?.publish(.failure(error))
                        self?.messageDeliveryService.stop()
                    }
                }))
            })
    }

    // MARK: - Internal helper functions

    private func publish(_ result: Result<CAIConversationResultData, CAIError>) {
        // ensure there is a subscriber
        guard let sub = self.subscriber else {
            assertionFailure("subscriber cannot be nil")
            self.logger.error("Subscriber to CAIConversation cannot be nil")
            return
        }
        
        _ = result.flatMapError { (error) -> Result<CAIConversationResultData, CAIError> in
            if error.type == .conversationNotFound {
                self.resetAndCreateConversation()
            }
            return .failure(error)
        }

        switch result {
        case .success(let response):
            self.logger.debug("publishing result with \(response.messages.count) messages")
            if let lastMsgId = response.messages.last?.id {
                self.messageDeliveryService.lastMessageId = lastMsgId
            }
            _ = sub.receive(.success(response))
        case .failure(let error):
            self.logger.error("Server Error", error: error)
            _ = sub.receive(.failure(error))
        }
    }
}

//
// extension CAIConversation {
//    func applyPreferences(_ preferences: CAIChannelPreferencesData) {
//        if case .fiori(_) = ThemeManager.shared.theme {
//            return
//        }
//        ThemeManager.shared.updateValues(with: preferences)
//    }
// }

// MARK: - Combin-ify APIs

public extension CAIConversation {
    /// Loads a conversation and returns a Publisher.
    /// Always emits on `Main` thread.
    /// - Parameter conversationId: String
    func loadConversation(_ conversationId: String) -> AnyPublisher<CAIResponseData, CAIError> {
        Future<CAIResponseData, CAIError> { promise in
            self.loadConversation(conversationId) { result in
                promise(result)
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
