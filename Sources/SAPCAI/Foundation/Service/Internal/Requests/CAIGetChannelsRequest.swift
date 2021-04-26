import Foundation
import SAPFoundation

struct CAIGetChannelsRequest: APIRequest {
    var method: String = SAPURLSession.HTTPMethod.get

    var path: String {
        "/channels/mobile/targetSystem/\(self.targetSystem)"
    }

    var parameters = [String: String]()

    var headers: [String: String] {
        var headers = [String: String]()
        if let token = developerToken {
            headers[SAPURLSession.HTTPHeader.XToken] = token
        }
        return headers
    }

    var httpBody: Data?

    var targetSystem: String

    var developerToken: String?

    init(targetSystem: String, developerToken: String? = nil) {
        self.targetSystem = targetSystem
        self.developerToken = developerToken
    }
}
