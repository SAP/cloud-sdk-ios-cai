import Combine
import Foundation
import SAPCAI

class DataModel: ObservableObject {
    var conversations = [String: (MessagingViewModel, CAIConversation)]() // stores conversationID per channelID
        
    init() {}

    func getModelFor(_ connection: Connection) -> MessagingViewModel {
        self.getModelFor(CAIChannel(id: connection.channelId, token: connection.channelToken, slug: connection.channelSlug), CAIChannelService(config: try! CAIServiceConfig.create(from: connection)), connection.conversationId)
    }
    
    func getModelFor(_ channel: CAIChannel, _ service: CAIChannelService, _ conversationId: String? = nil) -> MessagingViewModel {
        if let m = conversations[channel.id] {
            return m.0
        }

        let convId = (conversationId != nil && !conversationId!.isEmpty) ? conversationId : nil
        
        let delivery: MessageDelivering = PollMessageDelivery(channelToken: channel.token, channelId: channel.id, serviceConfig: service.serviceConfig)
        let conv = CAIConversation(config: service.serviceConfig, channel: channel, messageDelivery: delivery, withExistingConvID: convId)
        let m = MessagingViewModel(publisher: conv)
        
        // load preferences for this channel
        service.loadPreferences(channel: channel) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    m.menu = data?.menu
                case .failure:
                    break
                }
            }
        }
        
        self.conversations[channel.id] = (m, conv)
        return m
    }
    
    func clear() {
        self.conversations.forEach { _, value in
            value.0.cancelSubscriptions()
            value.1.resetConversation()
        }
        self.conversations.removeAll()
    }
}
