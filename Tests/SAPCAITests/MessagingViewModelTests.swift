import Combine
import Foundation
@testable import SAPCAI
import SAPFoundation
import XCTest

final class MessagingViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var urlSessionConfiguration: URLSessionConfiguration!

    override func setUp() {
        self.cancellables = []
        self.urlSessionConfiguration = URLSessionConfiguration.ephemeral
    }

    /*
      test scenario: create a conversation, post a messsage and receive a mocked respoonse
      note: all network requests are intercepted and the responses are mocked!
     */
    func testLoadAndPostMessage() {
        // test-case specific mock for potential network requests
        self.urlSessionConfiguration.protocolClasses = [NewConversationURLProtocolMock.self]

        let serviceConfig = CAIServiceConfig(urlSession: SAPURLSession(configuration: self.urlSessionConfiguration), host: URL(string: "https://api.cai.tools.sap")!)
        let channel = CAIChannel(id: "mockChannelId", token: "mockChannelToken", slug: "mockChannelSlug")
        let messageDeliveryService: MessageDelivering = PollMessageDelivery(channelToken: channel.token, channelId: channel.id, serviceConfig: serviceConfig)
        let messagingViewModel = MessagingViewModel(publisher: CAIConversation(config: serviceConfig, channel: channel, messageDelivery: messageDeliveryService))

        // load messages (== implicitly creates a new conversation)
        messagingViewModel.load()

        // post a message (for which a mock repsonse will eventually be returned)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messagingViewModel.postMessage(text: "Hi")
        }

        let receivedAllValues = expectation(description: "all values received")
        var sinkCalled = 0

        messagingViewModel.$acknowledgedMessages.sink { messages in
            sinkCalled += 1
            if messages.count == 2 {
                XCTAssertEqual(sinkCalled, 3)
                receivedAllValues.fulfill()
            }
        }.store(in: &self.cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /*
      test scenario: Load an invalid conversation. When 404 error occurs, it should internally create a new conversation. Now post a messsage and receive a mocked response
      note: all network requests are intercepted and the responses are mocked!
     */
    func testConversationNotFoundAndPostMessage() {
        // test-case specific mock for potential network requests
        self.urlSessionConfiguration.protocolClasses = [NewConversationURLProtocolMock.self]

        let serviceConfig = CAIServiceConfig(urlSession: SAPURLSession(configuration: self.urlSessionConfiguration), host: URL(string: "https://api.cai.tools.sap")!)
        let channel = CAIChannel(id: "mockChannelId", token: "mockChannelToken", slug: "mockChannelSlug")
        let messageDeliveryService: MessageDelivering = PollMessageDelivery(channelToken: channel.token, channelId: channel.id, serviceConfig: serviceConfig)
        // 404 response would be triggered with invalid conversation that internally creates a new conversation
        let messagingViewModel = MessagingViewModel(publisher: CAIConversation(config: serviceConfig, channel: channel, messageDelivery: messageDeliveryService, withExistingConvID: "InvalidConvId"))

        messagingViewModel.load()

        // post a message (for which a mock response will eventually be returned)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messagingViewModel.postMessage(text: "Hello")
        }

        let receivedAllValues = expectation(description: "all values received")
        var sinkCalled = 0

        messagingViewModel.$acknowledgedMessages.sink { messages in
            sinkCalled += 1
            if messages.count == 2 {
                XCTAssertEqual(sinkCalled, 3)
                receivedAllValues.fulfill()
            }
        }.store(in: &self.cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    enum Endpoint: String, RawRepresentable {
        case createConversation = "https://api.cai.tools.sap/connect/v1/webhook/mockChannelId/conversations"
        case poll = "https://api.cai.tools.sap/connect/v1/webhook/mockChannelId/conversations/f90ec53f-2265-4210-96f4-2c31d784e018/poll"
        case postMessage = "https://api.cai.tools.sap/connect/v1/webhook/mockChannelId"
        case pollAfterUserMessage = "https://api.cai.tools.sap/connect/v1/webhook/mockChannelId/conversations/f90ec53f-2265-4210-96f4-2c31d784e018/poll?last_message_id=4de52015-f281-4343-a3dd-04dff697e6bc"
        case pollAfterBotResponse = "https://api.cai.tools.sap/connect/v1/webhook/mockChannelId/conversations/f90ec53f-2265-4210-96f4-2c31d784e018/poll?last_message_id=fe0b20b2-56aa-4415-bc90-9d49b93c5720"
        case pollInvalidConversationResponse = "https://api.cai.tools.sap/connect/v1/webhook/mockChannelId/conversations/InvalidConvId/poll"
    }

    class NewConversationURLProtocolMock: URLProtocol {
        static var receivedRequests: [URLRequest] = []

        override class func canInit(with request: URLRequest) -> Bool {
            true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }

        override func startLoading() {
            NewConversationURLProtocolMock.receivedRequests.append(request)

            if let url = request.url {
                switch url.absoluteString {
                case Endpoint.createConversation.rawValue:
                    self.client?.urlProtocol(self, didLoad: self.getContent(of: "responseCreateConversation").data(using: .utf8)!)

                case Endpoint.poll.rawValue:
                    if NewConversationURLProtocolMock.receivedRequests.contains(where: { $0.url?.absoluteString == Endpoint.postMessage.rawValue }) {
                        self.client?.urlProtocol(self, didLoad: self.getContent(of: "responsePollUserMessage").data(using: .utf8)!)
                    } else {
                        self.client?.urlProtocol(self, didLoad: self.getContent(of: "responsePollEmpty").data(using: .utf8)!)
                    }

                case Endpoint.postMessage.rawValue:
                    self.client?.urlProtocol(self, didLoad: self.getContent(of: "responseMessageReceived").data(using: .utf8)!)

                case Endpoint.pollAfterUserMessage.rawValue:
                    self.client?.urlProtocol(self, didLoad: self.getContent(of: "responsePollBotMessage").data(using: .utf8)!)

                case Endpoint.pollAfterBotResponse.rawValue:
                    self.client?.urlProtocol(self, didLoad: self.getContent(of: "responsePollEmpty").data(using: .utf8)!)
                case Endpoint.pollInvalidConversationResponse.rawValue:
                    let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
                    self.client?.urlProtocol(self, didLoad: self.getContent(of: "responseInvalidConversation").data(using: .utf8)!)
                default:
                    fatalError("network call for \(url) is not mocked")
                }
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}

        private func getContent(of resourceName: String, ofType type: String = "json", inDirectory directory: String = "TestData") -> String {
            let path = Bundle.module.path(forResource: resourceName, ofType: type, inDirectory: directory) ?? "nonesense"
            return try! String(contentsOfFile: path)
        }
    }
}
