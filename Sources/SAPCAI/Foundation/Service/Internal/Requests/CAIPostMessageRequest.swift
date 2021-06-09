import Foundation
import SAPFoundation

struct CAIPostMessageRequest: APIRequest {
    var method: String = SAPURLSession.HTTPMethod.post
    var path: String {
        "/webhook/\(self.channelId)"
    }

    var parameters = [String: String]()
    var httpBody: Data?

    var conversationID: String
    var headers: [String: String] {
        var ret = [String: String]()
        ret[SAPURLSession.HTTPHeader.accept] = SAPURLSession.HTTPContentType.applicationJSON
        if self.httpBody != nil {
            ret[SAPURLSession.HTTPHeader.contentType] = SAPURLSession.HTTPContentType.applicationJSON
        }
        if let token = self.token {
            ret[SAPURLSession.HTTPHeader.XToken] = token
        }
        return ret
    }

    var token: String?

    var channelId: String

    init<T: CAIAttachmentData>(_ input: T, channelId: String, token: String?, conversationId: String, memoryOptions: MemoryOptions? = nil) throws {
        self.channelId = channelId
        self.token = token
        self.conversationID = conversationId
        self.httpBody = try self.createRequestBody(input: input, conversationID: self.conversationID, memoryOptions: memoryOptions)
    }

    private func createRequestBody<T: CAIAttachmentData>(input: T, conversationID: String, memoryOptions: MemoryOptions? = nil) throws -> Data {
        let reqData = CAIMessageRequestData(input, conversationID, memoryOptions: memoryOptions)
        return try JSONEncoder().encode(reqData)
    }
}
