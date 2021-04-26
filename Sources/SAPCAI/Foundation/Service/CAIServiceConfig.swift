import Foundation
import SAPFoundation

/// CAI Service definition. Helps to connect to CAI services. By default, it will connect to Community tenant.
public struct CAIServiceConfig {
    /// Backend host URL
    public let host: URL
        
    /// URLSession object used to make HTTP requests
    public let urlSession: SAPURLSession

    /// Developer Token
    public let developerToken: String?

    /// Read-only. Returns URL with host and channel connector endpoint
    public var baseURL: URL {
        self.host.appendingPathComponent(CAIServiceConfig.channelConnectorPath)
    }
    
    // MARK: - Internal
    
    let websocketBaseURL: URL
    
    /// Endpoint of channel connector
    private static let channelConnectorPath = "connect/v1"

    // MARK: - Functions
    
    /// Creates a new CAIServiceConfig
    /// - Parameters:
    ///   - sessionConfiguration: URLSessionConfiguration. Will create a SAPURLSession with this config
    ///   - host: URL. Optional. If nil, our Community Tenant URL will be used
    public init(sessionConfiguration: URLSessionConfiguration = .default, host: URL? = nil, developerToken: String? = nil) {
        self.init(urlSession: SAPURLSession(configuration: sessionConfiguration), host: host, developerToken: developerToken)
    }
    
    /// Creates a new CAIServiceConfig
    /// - Parameters:
    ///   - urlSession: SAPURLSession
    ///   - host: URL. Optional. If nil, our Community Tenant URL will be used
    public init(urlSession: SAPURLSession, host: URL? = nil, developerToken: String? = nil) {
        self.host = host ?? URL(string: "https://api.cai.tools.sap")!
        self.urlSession = urlSession
        self.developerToken = developerToken
//        if let wsUrl = websocketBaseUrl {
//            self.websocketBaseURL = wsUrl
//        }
//        else {
        let wsHost = self.host.absoluteString.replacingOccurrences(of: "https", with: "ws") // if https, then wss
        self.websocketBaseURL = URL(string: wsHost)!
//                                            .appendingPathComponent("websocket")
            .appendingPathComponent(CAIServiceConfig.channelConnectorPath)
            .appendingPathComponent("websocket")
//        }
    }
}
