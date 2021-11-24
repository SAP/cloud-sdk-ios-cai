import Combine
import Foundation
import SAPCommon

/// This class allows you to communicate with all CAI channel-related HTTP APIs
/// It implements ObservableObject to allow you to bind this object from your SwiftUI views
public final class CAIChannelService: ObservableObject {
    /// CAI Backend Service configuration
    public let serviceConfig: CAIServiceConfig
        
    /// Published. List of CAIChannel. Publishes new values when `loadsChannels` is called
    @Published public var channels = [CAIChannel]()
        
    private let logger = Logger.shared(named: "CAIFoundation.CAIChannelService")
    
    private var disposeBag = Set<AnyCancellable>()

    public init(config: CAIServiceConfig) {
        self.serviceConfig = config
    }
    
    deinit {
        disposeBag.removeAll()
    }
    
    /// Loads all channels for a specific target system ID and assign the return of the Future into self.channels`. Ignores any errors.
    /// - Parameter targetSystem: String
    public func loadChannels(for targetSystem: String) {
        Future<[CAIChannel], URLError> { promise in
            
            self.loadChannels(for: targetSystem) { result in
                promise(result)
            }
        }
        // .throttle(for: 3, scheduler: DispatchQueue.main, latest: true)
        .receive(on: DispatchQueue.main)
        .replaceError(with: [])
        .assign(to: \.channels, on: self)
        .store(in: &self.disposeBag)
    }
    
    /// Loads all channels for a specific target system ID and calls the completion handler to send the result
    /// - Parameters:
    ///   - targetSystem: String
    ///   - completionHandler: Handler function
    public func loadChannels(for targetSystem: String, _ completionHandler: @escaping (Result<[CAIChannel], URLError>) -> Void) {
        let request = CAIGetChannelsRequest(targetSystem: targetSystem, developerToken: serviceConfig.developerToken).urlRequest(with: self.serviceConfig.baseURL)
        self.serviceConfig.urlSession.dataTask(with: request) { data, response, error in
            
            var result: Result<[CAIChannel], URLError>
            defer {
                switch result {
                case .failure(let e):
                    self.logger.error("Unable to load channel list due to \(e)")
                case .success:
                    self.logger.info("channel list successfully loaded")
                }
                completionHandler(result)
            }
            
            self.logger.debug("loading channel list with url \(request.url?.absoluteString ?? "-")")
            guard error == nil else {
                result = .failure(URLError(.unknown))
                return
            }
            let e = URLError.lookForError(in: response)
            guard e == nil else {
                result = .failure(e!)
                return
            }
            
            guard let data = data else {
                result = .failure(URLError(.badServerResponse))
                return
            }
            
            do {
                let r = try JSONDecoder().decode(CAIChannelResult.self, from: data)
                result = .success(r.results)
            } catch {
                result = .failure(URLError(.unknown))
            }
        }.resume()
    }
    
    /// Loads the preferences for a channel
    /// - Parameters:
    ///   - channel: CAIChannel
    ///   - completionHandler: Handler function called when preferences are fetched
    public func loadPreferences(channel: CAIChannel, _ completionHandler: @escaping (Result<CAIChannelPreferencesData?, Error>) -> Void) {
        let request = CAIGetChannelPreferencesRequest(channel, channelToken: channel.token).urlRequest(with: self.serviceConfig.baseURL)
        
        self.serviceConfig.urlSession.dataTask(with: request) { data, response, error in
            
            var result: Result<CAIChannelPreferencesData?, Error>
            defer {
                completionHandler(result)
            }
            guard error == nil else {
                self.logger.error("Unable to load preferences for channel \(channel). Reason: \(error!)")
                result = .failure(error!)
                return
            }
            guard let data = data else {
                self.logger.error("Unable to load preferences for channel \(channel). No data.")
                result = .failure(URLError(.badServerResponse))
                return
            }
            
            if let e = URLError.lookForError(in: response) {
                self.logger.error("Invalid response while loading preferences for channel \(channel). Reason: \(e)")
                result = .failure(e)
                return
            }
            
            do {
                let prefs = try JSONDecoder().decode(CAIChannelPreferences.self, from: data)
                
                self.logger.info("successfully loaded preferences \(prefs)")

                result = .success(prefs.results)
            } catch {
                self.logger.error("Unable to parse preferences from data \(data.toString) due to error \(error.localizedDescription)")
                result = .failure(error)
            }
            
        }.resume()
    }
}
