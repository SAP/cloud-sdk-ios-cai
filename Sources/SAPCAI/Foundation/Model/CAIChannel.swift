import Foundation

/// Data model representing a Channel
public struct CAIChannel: Codable, Identifiable {
    /// id
    public var id: String

    /// channel specific token
    public var token: String?

    // slug (human-readable identifier)
    public var slug: String
    
//    public var webhook: String

    /// Initializer
    /// - Parameters:
    ///   - id: channel's id
    ///   - token: channel's token
    ///   - slug: channel's slug
    public init(id: String, token: String?, slug: String) {
        self.id = id
        self.token = token
        self.slug = slug
    }
}

struct CAIChannelResult: Decodable {
    var results: [CAIChannel]
}
