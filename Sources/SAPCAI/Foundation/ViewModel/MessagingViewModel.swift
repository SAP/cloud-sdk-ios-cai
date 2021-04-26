import Combine
import Foundation
import SwiftUI

/// MessagingViewModel is the key object that sits between the UI and the Model
/// It is a mandatory `EnvironmentObject` consumed by `AssistantView`
///
/// It implements `BindableObject` protocol which allows you to directly bind public
/// properties from your SwiftUI view
public final class MessagingViewModel: ObservableObject, Identifiable {
    // MARK: - Public properties

    /// Holds informatino about menu preferences
    @Published public var menu: PreferencesMenuData?

    /// messages over time (including non-acknowledged client initiated messages which will be removed (and quasi replaced) once bot acknowledges them)
    @Published public private(set) var model: [MessageData] = []

    /// messages returned by bot  over time
    @Published public private(set) var acknowledgedMessages: [MessageData] = []

    // MARK: - Private / Internal properties

    /// True when a backend request is pending
    @Published var isRequestPending = false

    /// urlOpenerData is used to display a link by presenting a modal window
    @Published var urlOpenerData = URLOpenerData()

    /// Holds information about available content height based on keyboard visibility
    @Published var contentHeight: CGFloat = 0
    
    @Published var latestError: Error?
    
    private var keyboardSubscriber: AnyCancellable?
        
    private var messageSubscription: Cancellable?
    
    private var messagePublisher: AnyMessagingPublisher<Result<ResponseMessageData, Error>, Never>

    /// messages sent by the user but not yet acknowledged / confirmed by the bot
    private var nonAcknowledgedClientMessages: [CAIResponseMessageData] = []
    
    // MARK: - Lifecycle

    /// Default initializer expects a messaging publisher
    public init<P: MessagingPublisher>(publisher: P) {
        self.messagePublisher = AnyMessagingPublisher(publisher)
        
        self.createSubscription(publisher)
        
        self.keyboardSubscriber = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .receive(on: RunLoop.main)
            .map { self.transform($0) }
            .sink(receiveCompletion: { completion in
                dlog(completion)
            }, receiveValue: { animation, height in
                withAnimation(animation) {
                    self.contentHeight = height
                }
            })
    }
    
    deinit {
        keyboardSubscriber?.cancel()
        messageSubscription?.cancel()
    }
    
    // MARK: - Public functions
    
    /// Update the current messaging publisher with a new one.
    /// The existing model will be cleared.
    /// - Parameter publisher: New publisher to bind to this view model.
    public func updatePublisher<P: MessagingPublisher>(_ publisher: P) {
        self.model.removeAll()
        self.acknowledgedMessages.removeAll()
        
        self.messagePublisher = AnyMessagingPublisher(publisher)
        
        self.createSubscription(publisher)
    }
    
    public func postMessage(text: String) {
        let userMessage = CAIResponseMessageData(text: text, false)
        nonAcknowledgedClientMessages.append(userMessage)
        self.model.append(userMessage)

        self.messagePublisher.postMessage(text: text)
    }
    
    public func postMessage(type: PostbackType, postbackData: PostbackData) {
        let userMessage = CAIResponseMessageData(text: postbackData.title, false)
        self.nonAcknowledgedClientMessages.append(userMessage)
        self.model.append(userMessage)

        self.messagePublisher.postMessage(type: type, postbackData: postbackData)
    }
        
    func getHeight(for geometry: GeometryProxy) -> CGFloat {
        if self.contentHeight > 0 {
            return geometry.size.height - self.contentHeight + geometry.safeAreaInsets.bottom
        } else {
            return geometry.size.height
        }
    }
    
    /// If you have your own View, you have to call this function when your view appear. It will be called  when `AssistantView` appears.
    public func load() {
        self.messagePublisher.load()
    }
    
    /// If you want to make sure this class gets deallocated correctly, you must cancel the subscriptions from the publisher. Call this function to do so.
    public func cancelSubscriptions() {
        self.messageSubscription?.cancel()
        self.keyboardSubscriber?.cancel()
    }

    // MARK: - Private functions
    
    private func removeAcknowledgedUserMessages(_ data: ResponseMessageData) {
        var messagesToBeDeleted: [String] = []
        data.messageData.filter { $0.sender.isBot == false }.forEach { acknowledgedClientMessage in
            if case .text(let acknowledgedUserMessageText) = acknowledgedClientMessage.type {
                self.nonAcknowledgedClientMessages.removeAll { (notAcknowledgedClientMessage) -> Bool in
                    if case .text(let notAcknowledgedUserMessageText) = notAcknowledgedClientMessage.type,
                       notAcknowledgedUserMessageText == acknowledgedUserMessageText
                    {
                        messagesToBeDeleted.append(notAcknowledgedClientMessage.id)
                        return true
                    } else {
                        return false
                    }
                }
            }
        }
        self.model.removeAll(where: { messagesToBeDeleted.contains($0.id) })
    }

    private func removeNonAcknowledgedClientMessages() {
        var messagesToBeDeleted: [String] = []
        self.nonAcknowledgedClientMessages.removeAll { (notAcknowledgedClientMessage) -> Bool in
            messagesToBeDeleted.append(notAcknowledgedClientMessage.id)
            return true
        }
        self.model.removeAll(where: { messagesToBeDeleted.contains($0.id) })
    }

    private func createSubscription<P: MessagingPublisher>(_ publisher: P) {
        // cancel existing subscription before calling new one
        self.messageSubscription?.cancel()
        
        self.messageSubscription = publisher
            // do not use `.receive(on: RunLoop.main)` as `.sink` would not be called due to a combine bug: https://forums.swift.org/t/sink-never-is-called-when-using-receive/27703/10
            .sink { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.latestError = nil
                        if data.isTyping {
                            self.isRequestPending = true
                        } else {
                            guard !data.messageData.isEmpty, let last = data.messageData.last else {
                                self.isRequestPending = false
                                return
                            }

                            if last.sender.isBot {
                                self.isRequestPending = false
                            }

                            self.removeAcknowledgedUserMessages(data)

                            self.model.append(contentsOf: data.messageData)
                            self.acknowledgedMessages.append(contentsOf: data.messageData)
                        }

                    case .failure(let error):
                        dlog(error)
                        self.isRequestPending = false
                        self.latestError = error

                        self.removeNonAcknowledgedClientMessages()
                    }
                }
            }
    }

    private func transform(_ notification: Notification) -> (Animation, CGFloat) {
        guard let kbFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
        
              let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else {
            return (self.getAnimation(0, 0), 0)
        }
        let kbHeight = max(0, UIScreen.main.bounds.size.height - kbFrame.origin.y)
        
        let animation = self.getAnimation(curve, duration)
        return (animation, kbHeight)
    }

    private func getAnimation(_ curve: UInt, _ duration: Double) -> Animation {
        let animationType = UIView.AnimationOptions(rawValue: curve)
                
        let animation: Animation
        switch animationType {
        case .curveEaseIn:
            animation = Animation.easeOut(duration: duration)
        case .curveEaseOut:
            animation = Animation.easeOut(duration: duration)
        case .curveEaseInOut:
            animation = Animation.easeInOut(duration: duration)
        default:
            animation = Animation.linear(duration: duration)
        }
        return animation
    }
}

public extension MessagingViewModel {
    /// :nodoc:
    func addMessage(_ data: MessageData) {
        self.model.append(data)
    }

    /// :nodoc:
    func addMessages(contentsOf arrayOfData: [MessageData]) {
        self.model.append(contentsOf: arrayOfData)
    }

    /// :nodoc:
    func remove(at index: Int) -> Bool {
        self.model.remove(at: index)
        return true
    }
}

/// isLinkModalPresented is true when url modal sheet is presented
/// url is the url string for the link
/// :nodoc:
public struct URLOpenerData {
    public var isLinkModalPresented: Bool = false
    public var url: String = ""
}

#if DEBUG

    let testData: MessagingViewModel = {
        let viewModel = MessagingViewModel(publisher: MockPublisher())
        viewModel.addMessages(contentsOf: [
            CAIResponseMessageData(text: "Hi"),
            CAIResponseMessageData(text: "Hey! How are you today?", true),
            CAIResponseMessageData(text: "**Some bold text**", true, markdown: true),
            CAIResponseMessageData(text: "Can you show me a movie released last year in July?"),
            CAIResponseMessageData("Avengers",
                                   "Adrift in space with no food or water, Tony Stark sends a message to Pepper Potts as his oxygen supply starts to dwindle.",
                                   nil, nil, nil, nil, nil, nil, nil, true),
            CAIResponseMessageData(imageName: "Product1")
        ])
    
        return viewModel
    
    }()
 
#endif
