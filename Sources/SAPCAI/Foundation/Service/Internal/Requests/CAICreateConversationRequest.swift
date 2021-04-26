import Foundation
import SAPFoundation

struct CAICreateConversationRequest: APIRequest {
    var method: String = SAPURLSession.HTTPMethod.post
    var path: String {
        "/webhook/\(self.channelId)/conversations"
    }

    var parameters = [String: String]()
    var headers: [String: String] {
        var ret = [String: String]()
        ret[SAPURLSession.HTTPHeader.accept] = SAPURLSession.HTTPContentType.applicationJSON
        if let token = self.token {
            ret[SAPURLSession.HTTPHeader.XToken] = token
        }
        return ret
    }

    var httpBody: Data?
    var channelId: String
    var token: String?

    init(channel: String, token: String?) {
        self.channelId = channel
        self.token = token
    }
}
