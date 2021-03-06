import Combine
import Foundation
import SAPCommon

/// Handles Long Polling mechanism to CAI Channel Connector to load messages
public class PollMessageDelivery: MessageDelivering {
    public var onMessages: ((Result<CAIConversationResultData, CAIError>) -> Void)?

    public var channelToken: String?

    public var channelId: String
        
    public var lastMessageId: String?
    
    private var serviceConfig: CAIServiceConfig
    
    private var requestQueue: OperationQueue = {
        let ret = OperationQueue()
        // serial queue since we want the poll endpoint to be called only at once
        ret.maxConcurrentOperationCount = 1
        ret.qualityOfService = .userInteractive
        return ret
    }()
    
    private var conversationId: String?

    private var state: State = .stopped {
        didSet {
            self.logger.debug("Polling \(self.state)")
        }
    }

    private var logger = Logger.shared(named: "PollMessageDelivery")

    private var serverPollingErrors: Int = 0
    
    enum State {
        case stopped
        case running
    }
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - channelId: String
    ///   - serviceConfig: CAIServiceConfig
    public init(channelToken: String?, channelId: String, serviceConfig: CAIServiceConfig) {
        self.channelToken = channelToken
        self.channelId = channelId
        self.serviceConfig = serviceConfig
    }

    deinit {
        self.logger.debug("poll deinit")
    }

    /// Start polling. Always return a publisher that emits true, never fails.
    public func reconnect() -> AnyPublisher<Bool, CAIError> {
        self.start()
        return Result.success(true).publisher.eraseToAnyPublisher()
    }

    public func initialize(_ conversationId: String) {
        self.conversationId = conversationId
        self.startPolling()
    }

    public func stop() {
        self.logger.debug("Consumer requested to stop polling")
        self._stop()
        self.serverPollingErrors = 0
    }

    public func start() {
        let typingMsg = CAIConversationResultData.isTyping
        self.onMessages?(.success(typingMsg))
        guard self.state == .stopped else { return }
        self.serverPollingErrors = 0
        self.startPolling()
    }

    private func _stop() {
        self.requestQueue.cancelAllOperations()
        self.state = .stopped
    }
    
    private func startPolling() {
        // cancel current operation
        self._stop()

        guard self.serverPollingErrors < 5 else {
            self.logger.error("Polling aborted due to too many server errors")
            return
        }
        
        // run
        self.state = .running
        let request = CAILoadConversationRequest(channelId: channelId, channelToken: channelToken, conversationId: conversationId!, lastMessageId: lastMessageId)
        let operation = CAILoadConversationOperation(self.serviceConfig, request: request) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let data):
                self.state = .stopped
                self.serverPollingErrors = 0

                let mapped = result.map { $0.results! }
                
                self.onMessages?(mapped)

                // stop polling in case the server returns a wait time different than 0
                let waitTime = data.results?.waitTime ?? 0
                DispatchQueue.global().asyncAfter(deadline: .now() + Double(waitTime)) {
                    self.startPolling()
                }

            case .failure(let error):
                self.logger.error(error.debugDescription, error: error)
                switch error.type {
                case .server:
                    self.serverPollingErrors += 1
                    self.startPolling()
                case .cancelled:
                    ()
                case .dataDecoding, .conversationNotFound:
                    self._stop()
                }
            }
        }
        self.requestQueue.addOperation(operation)
    }
}
