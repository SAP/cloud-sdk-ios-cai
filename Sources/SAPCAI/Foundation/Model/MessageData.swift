import Foundation
import SwiftUI

/// Protocol describing a response consumable by the `MessagingPublisher`
public protocol ResponseMessageData {
    /// True when server process the request and notifies the client to show a typing indicator
    var isTyping: Bool { get }
    
    /// Content of the response. Ignored if `isTyping` is true
    var messageData: [MessageData] { get }
}

/// A standard protocol representing a message.
/// Use this protocol to create your own message object to be used by the SDK.
public protocol MessageData {
    /// The unique identifier for the message.
    var id: String { get }
    
    /// The sender of the message.
    var sender: SenderInfo { get }
    
    /// The date the message was sent.
    var sentDate: Date { get }
    
    /// The type of message and its underlying data.
    var type: MessageType { get }
        
    /// List of postback actions for this message
    var buttons: [PostbackData]? { get }
    
    /// Return false if there are more pending messages coming.
    var isLastMessage: Bool { get }
}

/// An enum representing the kind of messages and its underlying content / data.
public enum MessageType {
    /// A standard text message.
    case text(String)
    
    /// A message with attributed text.
    case attributedText(NSAttributedString)
    
    /// A photo message.
    case picture(MediaItem)
    
    /// A video message.
    case video(MediaItem)
    
    /// An object message.
    case object(ObjectMessageData)

    /// A list message.
    case list(ListMessageData)

    /// A form message.
    case form(FormMessageData)
    
    /// A buttons message.
    case buttons(ButtonsMessageData)
    
    /// A quickReplies message.
    case quickReplies(ButtonsMessageData)
    
    /// A carousel message.
    case carousel(CarouselMessageData)
    
    /// A custom message.
    case custom(AnyViewable)
    
    /// Unknown type message
    case unknown
}

/// Protocol describing custom content provided by application team to render a custom unsupported cell. Holds the data and the view.
///
/// @see `MessageType`
public protocol AnyViewable {
    /// Holds the actual view tree
    var view: AnyView { get }
    
    /// Holds data to render the view
    var viewData: Any? { get }
}

/// Protocol describing details about the sender of a message
public protocol SenderInfo {
    /// Identifier
    var id: String { get }

    /// Display name of sender
    var displayName: String { get }

    /// Is sender a bot or not
    var isBot: Bool { get }
}

/// Enums for supported postback type
public enum PostbackType: String {
    /// button
    case button
    /// quick reply
    case quickReply
}

/// Protocol describing the details of an Postback data
public protocol PostbackData {
    /// Identifier
    var id: String { get }

    /// Title
    var title: String { get }

    /// Data type of postback data
    var dataType: PostbackDataType { get }

    /// Value in textual representation
    var value: String { get }
}

/// Protocol describing the details of a content Value data
public protocol ValueData {
    /// Identifier
    var id: String { get }

    /// Label
    var label: String? { get }

    /// Type
    var type: UIModelData.ValueType? { get }

    /// Value in textual representation
    var value: String? { get }

    /// Value state
    var valState: UIModelData.ValueState { get }

    /// Raw value
    var rawValue: String? { get }
}

/// Enumeration for possible postback types
public enum PostbackDataType: String {
    /// text
    case text = "TEXT"
    /// callback
    case callback = "CALLBACK"
    /// link
    case link
    /// url
    case url = "web_url"
    /// postback
    case postback
    /// phone number
    case phoneNumber = "phonenumber"
    /// trigger skill
    case triggerSkill = "trigger_skill"
}

// FIXME: temporary extension until ViewBuilder supports switch statement
extension MessageData {
    var isText: Bool {
        if case .text = type {
            return true
        }
        if case .attributedText = type {
            return true
        }
        return false
    }

    var isPicture: Bool {
        if case .picture = type {
            return true
        }
        return false
    }
    
    var isVideo: Bool {
        if case .video = type {
            return true
        }
        return false
    }

    var isObject: Bool {
        if case .object = type {
            return true
        }
        return false
    }

    var isList: Bool {
        if case .list = type {
            return true
        }
        return false
    }
    
    var isForm: Bool {
        if case .form = type {
            return true
        }
        return false
    }
    
    var isButtons: Bool {
        if case .buttons = type {
            return true
        }
        return false
    }
    
    var isQuickReplies: Bool {
        if case .quickReplies = type {
            return true
        }
        return false
    }
    
    var isCarousel: Bool {
        if case .carousel = type {
            return true
        }
        return false
    }
    
    var isCustom: Bool {
        if case .custom = type {
            return true
        }
        return false
    }
    
    var getObject: ObjectMessageData? {
        if case .object(let data) = type {
            return data
        }
        return nil
    }
    
    var customView: AnyViewable? {
        if case .custom(let viewable) = type {
            return viewable
        }
        return nil
    }
    
    var isUnknown: Bool {
        if case .unknown = type {
            return true
        }
        return false
    }
}
