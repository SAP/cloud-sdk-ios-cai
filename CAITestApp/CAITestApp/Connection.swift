import SAPCAI
import SwiftUI

public class Connection: ObservableObject, Codable {
    public var id: String {
        self.name
    }

    @Published var name: String = ""

    // System - Login / Authentication
    @Published var baseURL: String = ""
    @Published var authorizationEndpointURL: String = ""
    @Published var tokenEndpointURL: String = ""
    @Published var redirectURL: String = ""
    @Published var clientId: String = ""
    @Published var clientSecret: String = ""

    // CAI - Bot Settings
    @Published var developerToken: String = ""

    // CAI - Bot - Channel
    @Published var channelId: String = ""
    @Published var channelToken: String = ""
    @Published var channelSlug: String = ""

    // CAI - Bot - Channel - Conversation
    @Published var conversationId: String = ""

    init() {}

    init(name: String = "", baseURL: String = "", authorizationEndpointURL: String = "", tokenEndpointURL: String = "", redirectURL: String = "", clientId: String = "", clientSecret: String = "", developerToken: String = "", channelId: String = "", channelToken: String = "", channelSlug: String = "", conversationId: String = "") {
        self.name = name
        self.baseURL = baseURL
        self.authorizationEndpointURL = authorizationEndpointURL
        self.tokenEndpointURL = tokenEndpointURL
        self.redirectURL = redirectURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.developerToken = developerToken
        self.channelId = channelId
        self.channelToken = channelToken
        self.channelSlug = channelSlug
        self.conversationId = conversationId
    }

    func update(basedOn connection: Connection) {
        self.name = connection.name
        self.baseURL = connection.baseURL
        self.authorizationEndpointURL = connection.authorizationEndpointURL
        self.tokenEndpointURL = connection.tokenEndpointURL
        self.redirectURL = connection.redirectURL
        self.clientId = connection.clientId
        self.clientSecret = connection.clientSecret
        self.developerToken = connection.developerToken
        self.channelId = connection.channelId
        self.channelToken = connection.channelToken
        self.channelSlug = connection.channelSlug
        self.conversationId = connection.conversationId
    }

    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: self.name)
        }
    }

    static func loadFromUserDefaults(with name: String) -> Connection? {
        if let connection = UserDefaults.standard.object(forKey: name) as? Data {
            let decoder = JSONDecoder()
            if let loadedConnection = try? decoder.decode(Connection.self, from: connection) {
                return loadedConnection
            }
        }
        return nil
    }

    // MARK: Codable

    enum CodingKeys: CodingKey {
        case name, baseURL, authorizationEndpointURL, tokenEndpointURL, redirectURL, clientId, clientSecret, developerToken, channelId, channelToken, channelSlug, conversationId
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.name, forKey: .name)
        try container.encode(self.baseURL, forKey: .baseURL)
        try container.encode(self.authorizationEndpointURL, forKey: .authorizationEndpointURL)
        try container.encode(self.tokenEndpointURL, forKey: .tokenEndpointURL)
        try container.encode(self.redirectURL, forKey: .redirectURL)
        try container.encode(self.clientId, forKey: .clientId)
        try container.encode(self.clientSecret, forKey: .clientSecret)
        try container.encode(self.developerToken, forKey: .developerToken)
        try container.encode(self.channelId, forKey: .channelId)
        try container.encode(self.channelToken, forKey: .channelToken)
        try container.encode(self.channelSlug, forKey: .channelSlug)
        try container.encode(self.conversationId, forKey: .conversationId)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.baseURL = try container.decode(String.self, forKey: .baseURL)
        self.authorizationEndpointURL = try container.decode(String.self, forKey: .authorizationEndpointURL)
        self.tokenEndpointURL = try container.decode(String.self, forKey: .tokenEndpointURL)
        self.redirectURL = try container.decode(String.self, forKey: .redirectURL)
        self.clientId = try container.decode(String.self, forKey: .clientId)
        self.clientSecret = try container.decodeIfPresent(String.self, forKey: .clientSecret) ?? ""
        self.developerToken = try container.decodeIfPresent(String.self, forKey: .developerToken) ?? ""
        self.channelId = try container.decodeIfPresent(String.self, forKey: .channelId) ?? ""
        self.channelToken = try container.decodeIfPresent(String.self, forKey: .channelToken) ?? ""
        self.channelSlug = try container.decodeIfPresent(String.self, forKey: .channelSlug) ?? ""
        self.conversationId = try container.decodeIfPresent(String.self, forKey: .conversationId) ?? ""
    }
}
