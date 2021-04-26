/// Protocol describing the details of a preferences menu data
public protocol PreferencesMenuData {
    var menuData: MenuData? { get }
}

/// Protocol describing the details of a menu data
public protocol MenuData {
    var menuActions: [MenuAction] { get }
}

/// Protocol describing the details of a menu action
public protocol MenuAction {
    var actionId: String { get }
    
    var menuTitle: String { get }
        
    var actionType: MenuActionType { get }
    
    var value: String? { get }
    
    var menuActions: [MenuAction]? { get }
}

/// Enums for supported menu action type
public enum MenuActionType: String, Equatable {
    case link = "Link"
    case postBack = "postback"
    case nested
}
