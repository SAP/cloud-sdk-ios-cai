import Foundation

/// Holds model for a channel preferences
public struct CAIChannelPreferencesData: Decodable {
    var accentColor: String?
    var backgroundColor: String?

    var headerTitle: String?
    var openingType: String?
    var botPicture: String?
    var botMessageColor: String?
    var botMessageBackgroundColor: String?
    var welcomeMessage: String?

    /// Holds model for a channel preferences menu
    public var menu: CAIChannelPreferencesMenuData?

    /// Initializer
    public init() {}
}

/// Holds model for a channel preferences menu
public struct CAIChannelPreferencesMenuData: Decodable {
    var locale: String
    var menu: CAIChannelMenuData?
}

/// Holds model for a channel menu object
public struct CAIChannelMenuData: Decodable {
    var locale: String
    var call_to_actions: [CAIChannelMenuDataAction]

    /// Initializer
    public init(_ locale: String, _ callToActions: [CAIChannelMenuDataAction]) {
        self.locale = locale
        self.call_to_actions = callToActions
    }
}

/// Holds model for a channel menu call to actions
public struct CAIChannelMenuDataAction: Decodable {
    let id: String
    var title: String
    var type: String
    var payload: String?
    var call_to_actions: [CAIChannelMenuDataAction]?

    /// Initializer
    public init(_ title: String, _ type: String, _ payload: String?, _ callToActions: [CAIChannelMenuDataAction]?) {
        self.id = UUID().uuidString
        self.title = title
        self.type = type
        self.payload = payload
        self.call_to_actions = callToActions
    }
}

/// Make CAIChannelPreferencesData conforms to Themeable
///
// TODO: all  properties that can be customized should be added
// extension CAIChannelPreferencesData: Themeable {
//
//    var themeableValues: [Theme.Key: Any] {
//
//        var result = [Theme.Key: Any]()
//
//        if let pic = botPicture {
//            result[.avatarUrl] = pic
//        }
//
//        return result
//
//    }
// }

// MARK: Conformance to PreferencesMenuData protocol

extension CAIChannelPreferencesMenuData: PreferencesMenuData {
    /// menu data
    public var menuData: MenuData? {
        self.menu
    }

    /// Initializer
    public init(_ locale: String, _ menu: CAIChannelMenuData?) {
        self.locale = locale
        self.menu = menu
    }
}

// MARK: Conformance to MenuData protocol

extension CAIChannelMenuData: MenuData {
    /// menu actions
    public var menuActions: [MenuAction] {
        self.call_to_actions
    }
}

// MARK: Conformance to MenuAction protocol

extension CAIChannelMenuDataAction: MenuAction {
    /// action id
    public var actionId: String {
        self.id
    }

    /// menu title
    public var menuTitle: String {
        self.title
    }

    /// action type
    public var actionType: MenuActionType {
        MenuActionType(rawValue: self.type) ?? .postBack
    }

    /// payload
    public var value: String? {
        self.payload
    }

    /// nested menu actions
    public var menuActions: [MenuAction]? {
        self.call_to_actions
    }
}

struct CAIChannelPreferences: Decodable {
    var message: String?
    var results: CAIChannelPreferencesData?

    init() {}
}
