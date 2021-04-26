import Combine
import Foundation
import SAPCAI
import SAPFoundation

enum CAIServiceConfigCreatingError: Error {
    case incorrectURL
}

extension CAIServiceConfig {
    static func create(from connection: Connection) throws -> CAIServiceConfig {
        let session = SAPURLSession()

        let secureKeyValueStore = SecureKeyValueStore()
        try secureKeyValueStore.open(with: "cai_secure_store")
        let compositeStore = CompositeStorage()
        try compositeStore.setPersistentStore(secureKeyValueStore)

        if let authorizationEndpointURL = URL(string: connection.authorizationEndpointURL),
           let redirectURL = URL(string: connection.redirectURL),
           let tokenEndpointURL = URL(string: connection.tokenEndpointURL)
        {
            // App-specific OAuth settings as defined in Mobile Services and what normally be part of a `ConfigurationProvider.plist` of an Assistant generated project
            // No client secret of CAI needed :)
            let params = OAuth2AuthenticationParameters(authorizationEndpointURL: authorizationEndpointURL,
                                                        clientID: connection.clientId,
                                                        redirectURL: redirectURL,
                                                        tokenEndpointURL: tokenEndpointURL,
                                                        clientSecret: connection.clientSecret)

            let authenticator = OAuth2Authenticator(authenticationParameters: params, webViewPresenter: WKWebViewPresenter())
            let oauthObserver = OAuth2Observer(authenticator: authenticator, tokenStore: OAuth2TokenStorage(store: compositeStore))

            session.register(oauthObserver)

            // use the mobile service destination as base URL
            return CAIServiceConfig(urlSession: session, host: URL(string: connection.baseURL), developerToken: connection.developerToken.isEmpty ? nil : connection.developerToken)

        } else {
            throw CAIServiceConfigCreatingError.incorrectURL
        }
    }
}
