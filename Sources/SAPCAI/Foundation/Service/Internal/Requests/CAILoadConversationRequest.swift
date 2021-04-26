import Foundation
import SAPFoundation

struct CAILoadConversationRequest: APIRequest {
    var lastMessageId: String?

    var method: String = SAPURLSession.HTTPMethod.get

    var path: String {
        "/webhook/\(self.channelId)/conversations/\(self.conversationId)/poll"
    }

    var parameters: [String: String] {
        var params = [String: String]()

        if let msgId = lastMessageId {
            params["last_message_id"] = msgId
        }

        return params
    }

    var headers: [String: String] {
        var headers = [String: String]()
        if let token = self.channelToken {
            headers[SAPURLSession.HTTPHeader.XToken] = token
        }
        return headers
    }

    var httpBody: Data?

    var conversationId: String

    var channelId: String

    var channelToken: String?

    init(channelId: String, channelToken: String?, conversationId: String, lastMessageId: String?) {
        self.channelId = channelId
        self.channelToken = channelToken
        self.conversationId = conversationId
        self.lastMessageId = lastMessageId
    }
}
