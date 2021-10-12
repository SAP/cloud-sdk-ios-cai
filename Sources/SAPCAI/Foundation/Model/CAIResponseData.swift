import Foundation
import SwiftUI

public enum CAIMessageType: String, Decodable {
    case typing
    case data
}

/// :nodoc:
/// Internal. We only expose CAIConversationResultData
public struct CAIResponseData: Decodable {
    var message: String
    var results: CAIConversationResultData?
}

/// Main Data Model for `CAIConversation`.
public struct CAIConversationResultData: Decodable {
    public var messages = [CAIResponseMessageData]()
    
    public var channel: String?
    
    public var chatId: String?
    
    public var connector: String?
    
    public var fallbacked: Bool?
    
    public var id: String?
    
    public var waitTime: Int? = 0
    
    /// String. Should be one of the available `CAIMessageType`
    public var type: String?
    
    var _type: CAIMessageType {
        CAIMessageType(rawValue: self.type ?? "data") ?? .data
    }
    
    private init(type: CAIMessageType) {
        self.type = type.rawValue
    }
    
    init(_ messages: [CAIResponseMessageData]) {
        self.messages = messages
    }
    
    /// Static instance of typing indicator
    public static var isTyping = CAIConversationResultData(type: .typing)
}

/// Data Model structure for messages returned by CAI platform
public struct CAIResponseMessageData: Decodable, Identifiable {
    public var id: String
    public var participant: CAIResponseParticipantData
    public var attachment: UIModelData
    public var conversation: String
    public var receivedAt: Date?

    public init(id: String, participant: CAIResponseParticipantData, attachment: UIModelData, conversation: String, receivedAt: Date?) {
        var attachment = attachment
        attachment.processData()
        
        self.id = id
        self.participant = participant
        self.attachment = attachment
        self.conversation = conversation
        self.receivedAt = receivedAt
    }
    
    enum CAIResponseMessageDataKeys: CodingKey {
        case id
        case participant
        case attachment
        case conversation
        case receivedAt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CAIResponseMessageDataKeys.self) // defining our (keyed) container
        let id = try container.decode(String.self, forKey: .id)
        let participant = try container.decode(CAIResponseParticipantData.self, forKey: .participant)
        let attachment = try container.decode(UIModelData.self, forKey: .attachment)
        let conv = try container.decode(String.self, forKey: .conversation)
        let receivedAt = try? container.decode(Date.self, forKey: .receivedAt)
        
        self.init(id: id, participant: participant, attachment: attachment, conversation: conv, receivedAt: receivedAt)
    }
}

extension CAIResponseMessageData: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: Conformance to ResponseMessageData protocol

extension CAIConversationResultData: ResponseMessageData {
    public var messageData: [MessageData] {
        self.messages
    }
    
    public var isTyping: Bool {
        self._type == .typing
    }
}

// MARK: Conformance to MessageData protocol

extension CAIResponseMessageData: MessageData {
    public var sender: SenderInfo {
        self.participant
    }
    
    public var sentDate: Date {
        self.receivedAt ?? Date()
    }
    
    public var type: MessageType {
        assert(self.attachment.content != nil, "Corrupted data, content cannot be nil.")
        
        switch self.attachment.vizType {
        case .text,
             .TEXT:
            if self.attachment.markdown == true, self.attachment.content!.markdownText != nil {
                return .attributedText(self.attachment.content!.markdownText!)
            } else {
                return .text(self.attachment.content!.text!)
            }
        case .object:
            return .object(self.attachment.content!)
        case .form:
            return .form(self.attachment)
        case .list:
            return .list(self.attachment)
        case .video:
            return .video(self.attachment.content!.video!)
        case .picture:
            return .picture(self.attachment.content!.picture!)
        case .quickReplies:
            return .quickReplies(self.attachment)
        case .buttons:
            return .buttons(self.attachment)
        case .carousel:
            return .carousel(self.attachment)
        case .unknown:
            return .unknown
        }
    }
    
    public var buttons: [PostbackData]? {
        switch self.attachment.vizType {
        default:
            return self.attachment.buttons
        }
    }
    
    public var isLastMessage: Bool {
        self.attachment.delay == nil || self.attachment.delay == 0
    }

    public var delay: TimeInterval? {
        self.attachment.delay
    }
}

public struct CAIResponseParticipantData: Decodable {
    public var isBot: Bool
    public var senderId: String
}

// MARK: Conformance to SenderInfo protocol

extension CAIResponseParticipantData: SenderInfo {
    public var id: String {
        self.senderId
    }
    
    /// In CAI, we don't have a display name for sender. Either you or the bot/assistant
    public var displayName: String {
        ""
    }
}

// MARK: Helper functions to create CAI message data objects

public extension CAIResponseMessageData {
    init(text: String, _ isBot: Bool = true, markdown: Bool = false) {
        var content = UIModelDataContent()
        content.text = text
        var modelData = UIModelData(type: VisualizationType.text.rawValue,
                                    delay: nil,
                                    header: nil,
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        modelData.markdown = markdown
        
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }
    
    init(text: String, _ inlineButtons: [UIModelDataAction]?, buttonType: VisualizationType, _ isBot: Bool = true) {
        var content = UIModelDataContent()
        content.text = text
        content.buttons = inlineButtons

        assert(buttonType == .buttons || buttonType == .quickReplies, "Only buttons and quickReplies are allowed")
       
        let modelData = UIModelData(type: buttonType.rawValue,
                                    delay: nil,
                                    header: nil,
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }

    @available(*, deprecated, message: "Use init(title:subtitle:headerImageName:contentPictureName:description:inlineButtons:sections:status1:status1ValueState:status2:status3:isBot)")
    init(_ title: String,
         _ subtitle: String,
         _ headerImageName: String? = nil, // e.g. image in object card
         _ contentPictureName: String? = nil, // e.g. image for carousel card
         _ description: String? = nil,
         _ inlineButtons: [UIModelDataAction]? = nil,
         _ sections: [UIModelDataSection]? = nil,
         _ status1: String? = nil,
         _ status2: String? = nil,
         _ status3: String? = nil,
         _ isBot: Bool = true)
    {
        var content: UIModelDataContent?
        content = UIModelDataContent()
        if inlineButtons != nil {
            content?.buttons = inlineButtons
        }
        if sections != nil {
            content?.sections = sections
        }
        content?.header = UIModelDataHeader(title: UIModelDataValue(value: title, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            subtitle: UIModelDataValue(value: subtitle, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            description: UIModelDataValue(value: description,
                                                                          dataType: UIModelData.ValueType.text.rawValue,
                                                                          rawValue: nil,
                                                                          label: nil,
                                                                          valueState: nil),
                                            status1: UIModelDataValue(value: status1, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            status2: UIModelDataValue(value: status2, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            status3: UIModelDataValue(value: status3, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            image: nil)
        if let img = headerImageName {
            content?.header?.image = UIModelDataImage(imageUrl: img)
        }
        if let img = contentPictureName {
            content?.picture = UIModelDataMedia(url: img)
        }
               
        var modelData = UIModelData(type: VisualizationType.object.rawValue,
                                    delay: nil,
                                    header: UIModelDataHeader(title: UIModelDataValue(value: title,
                                                                                      dataType: UIModelData.ValueType.text.rawValue,
                                                                                      rawValue: nil,
                                                                                      label: nil,
                                                                                      valueState: nil),
                                                              subtitle: UIModelDataValue(value: subtitle,
                                                                                         dataType: UIModelData.ValueType.text.rawValue,
                                                                                         rawValue: nil,
                                                                                         label: nil,
                                                                                         valueState: nil),
                                                              description: UIModelDataValue(value: description,
                                                                                            dataType: UIModelData.ValueType.text.rawValue,
                                                                                            rawValue: nil,
                                                                                            label: nil,
                                                                                            valueState: nil),
                                                              status1: UIModelDataValue(value: status1, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                                              status2: UIModelDataValue(value: status2, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                                              status3: UIModelDataValue(value: status3, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                                              image: nil),
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        
        if let img = headerImageName {
            modelData.header?.image = UIModelDataImage(imageUrl: img)
        }
        
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }

    init(title: String,
         subtitle: String,
         headerImageName: String? = nil, // e.g. image in object card
         featuredImageName: String? = nil, // e.g. image for carousel card
         description: String? = nil,
         inlineButtons: [UIModelDataAction]? = nil,
         sections: [UIModelDataSection]? = nil,
         status1: String? = nil,
         status1_state: UIModelData.ValueState? = nil,
         status2: String? = nil,
         status2_state: UIModelData.ValueState? = nil,
         status3: String? = nil,
         status3_state: UIModelData.ValueState? = nil,
         isBot: Bool = true)
    {
        var content: UIModelDataContent?
        content = UIModelDataContent()
        if inlineButtons != nil {
            content?.buttons = inlineButtons
        }
        if sections != nil {
            content?.sections = sections
        }
        content?.header = UIModelDataHeader(title: UIModelDataValue(value: title, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            subtitle: UIModelDataValue(value: subtitle, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                            description: UIModelDataValue(value: description,
                                                                          dataType: UIModelData.ValueType.text.rawValue,
                                                                          rawValue: nil,
                                                                          label: nil,
                                                                          valueState: nil),
                                            status1: UIModelDataValue(value: status1, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: status1_state?.rawValue),
                                            status2: UIModelDataValue(value: status2, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: status2_state?.rawValue),
                                            status3: UIModelDataValue(value: status3, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: status3_state?.rawValue),
                                            image: nil)
        if let img = headerImageName {
            content?.header?.image = UIModelDataImage(imageUrl: img)
        }
        if let img = featuredImageName {
            content?.picture = UIModelDataMedia(url: img)
        }

        var modelData = UIModelData(type: VisualizationType.object.rawValue,
                                    delay: nil,
                                    header: UIModelDataHeader(title: UIModelDataValue(value: title,
                                                                                      dataType: UIModelData.ValueType.text.rawValue,
                                                                                      rawValue: nil,
                                                                                      label: nil,
                                                                                      valueState: nil),
                                                              subtitle: UIModelDataValue(value: subtitle,
                                                                                         dataType: UIModelData.ValueType.text.rawValue,
                                                                                         rawValue: nil,
                                                                                         label: nil,
                                                                                         valueState: nil),
                                                              description: UIModelDataValue(value: description,
                                                                                            dataType: UIModelData.ValueType.text.rawValue,
                                                                                            rawValue: nil,
                                                                                            label: nil,
                                                                                            valueState: nil),
                                                              status1: UIModelDataValue(value: status1, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                                              status2: UIModelDataValue(value: status2, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                                              status3: UIModelDataValue(value: status3, dataType: UIModelData.ValueType.text.rawValue, rawValue: nil, label: nil, valueState: nil),
                                                              image: nil),
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)

        if let img = headerImageName {
            modelData.header?.image = UIModelDataImage(imageUrl: img)
        }

        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }
    
    init(imageName: String, _ isBot: Bool = true) {
        var content = UIModelDataContent()
        content.picture = UIModelDataMedia(url: imageName, width: 800, height: 600)
        let modelData = UIModelData(type: VisualizationType.picture.rawValue,
                                    delay: nil,
                                    header: nil,
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }
    
    init(videoUrl: String, _ isBot: Bool = true) {
        var content = UIModelDataContent()
        content.video = UIModelDataMedia(url: videoUrl)
        let modelData = UIModelData(type: VisualizationType.video.rawValue,
                                    delay: nil,
                                    header: nil,
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }
    
    init(_ mockData: [UIModelDataContent], _ inlineButtons: [UIModelDataAction]? = nil, _ title: String, _ subtitle: String, _ description: String? = nil, _ isBot: Bool = true) {
        var content = UIModelDataContent()
        content.list = mockData
        content.header = UIModelDataHeader(title: UIModelDataValue(value: title,
                                                                   dataType: UIModelData.ValueType.text.rawValue,
                                                                   rawValue: nil,
                                                                   label: nil,
                                                                   valueState: nil),
                                           subtitle: UIModelDataValue(value: subtitle,
                                                                      dataType: UIModelData.ValueType.text.rawValue,
                                                                      rawValue: nil,
                                                                      label: nil,
                                                                      valueState: nil),
                                           description: UIModelDataValue(value: description,
                                                                         dataType: UIModelData.ValueType.text.rawValue,
                                                                         rawValue: nil,
                                                                         label: nil,
                                                                         valueState: nil),
                                           status1: nil,
                                           status2: nil,
                                           status3: nil,
                                           image: nil)
        if inlineButtons != nil {
            content.buttons = inlineButtons
        }
        let modelData = UIModelData(type: VisualizationType.list.rawValue,
                                    delay: nil,
                                    header: UIModelDataHeader(title: UIModelDataValue(value: title,
                                                                                      dataType: UIModelData.ValueType.text.rawValue,
                                                                                      rawValue: nil,
                                                                                      label: nil,
                                                                                      valueState: nil),
                                                              subtitle: UIModelDataValue(value: subtitle,
                                                                                         dataType: UIModelData.ValueType.text.rawValue,
                                                                                         rawValue: nil,
                                                                                         label: nil,
                                                                                         valueState: nil),
                                                              description: UIModelDataValue(value: description,
                                                                                            dataType: UIModelData.ValueType.text.rawValue,
                                                                                            rawValue: nil,
                                                                                            label: nil,
                                                                                            valueState: nil),
                                                              status1: nil,
                                                              status2: nil,
                                                              status3: nil,
                                                              image: nil),
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }
    
    init(_ mockData: [UIModelDataContent], _ isBot: Bool = true) {
        var content = UIModelDataContent()
        content.carousel = mockData
        
        let modelData = UIModelData(type: VisualizationType.carousel.rawValue,
                                    delay: nil,
                                    header: nil,
                                    content: content,
                                    detailsAvailable: false,
                                    buttons: nil)
        self.init(id: UUID().uuidString,
                  participant: CAIResponseParticipantData(isBot: isBot, senderId: "botA"),
                  attachment: modelData,
                  conversation: "",
                  receivedAt: Date())
    }
}
