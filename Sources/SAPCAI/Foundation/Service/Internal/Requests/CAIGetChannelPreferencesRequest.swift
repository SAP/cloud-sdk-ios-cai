import Foundation
import SAPFoundation

struct CAIGetChannelPreferencesRequest: APIRequest {
    var method: String = SAPURLSession.HTTPMethod.get

    var path: String {
        "/webhook/\(self.channel.id)/preferences"
    }

    var parameters = [String: String]()

    var headers: [String: String] {
        var headers = [String: String]()
        headers[SAPURLSession.HTTPHeader.XToken] = self.channelToken
        return headers
    }

    var httpBody: Data?

    var channel: CAIChannel

    var channelToken: String?

    init(_ channel: CAIChannel, channelToken: String?) {
        self.channel = channel
        self.channelToken = channelToken
    }
}
