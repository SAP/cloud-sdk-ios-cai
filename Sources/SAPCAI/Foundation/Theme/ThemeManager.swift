import Combine
import Foundation
import SwiftUI

/// Available themes to consume by your application
///
/// CAI provides 2 themes:
///  - Fiori. Follows SAP Fiori Design Language. Mostly used in Enterprise context
///  - Casual. Mostly used in Community context
///
/// Both provide support light & dark mode.
///
/// You can also provide you own custom theme.
///
/// For Casual and Fiori, you only need to provide a Color palette. We have a default color palette for both of them but you can provide your own Color palette.
///
/// If you want to use a custom theme, you need to provide a Theme struct as well as a Color palette for it and it's your responsibility to support light & dark mode.
/// @see Theme.Key to know what keys you can configure.
///
public enum CAITheme: CustomStringConvertible {
    @available(*, deprecated, message: "The casual theme is no longer maintained and will be removed in a future version. Use the standard Fiori theme or a custom theme")
    /// **No longer maintained!** Use the standard Fiori theme or a custom theme
    case casual(ColorPalette)

    ///Fiori theme follows SAP Fiori Design Language
    case fiori(ColorPalette)

    case custom(Theme, ColorPalette)

    /// Get ColorPalette (read-only)
    public var palette: ColorPalette {
        switch self {
        case .casual(let palette),
             .fiori(let palette):
            return palette
        case .custom(_, let palette):
            return palette
        }
    }
    
    /// Get underlying Theme object (read-only)
    public var theme: Theme {
        switch self {
        case .casual:
            return CAITheme.casualTheme
        case .fiori:
            return CAITheme.fioriTheme
        case .custom(let t, _):
            return t
        }
    }
    
    /// :nodoc:
    public var description: String {
        switch self {
        case .fiori(let p):
            return "Fiori (\(p.name))"
        case .casual(let p):
            return "Casual (\(p.name))"
        case .custom(let t, let p):
            return "\(t.name) (\(p.name))"
        }
    }

    /// Binds this method in your SwiftUI Views to get the color for the current theme
    /// - Parameter key: Theme.Key
    /// - Returns: Color
    public func color(for key: Theme.Color.Key) -> Color {
        self.palette.color(for: key)
    }

    /// Binds this method in your SwiftUI Views to get the value for the current theme
    /// - Parameter key: Theme.Key
    /// - Returns: Any. Nil if key is not found
    public func value(for key: Theme.Key) -> Any? {
        switch self {
        case .casual:
            return CAITheme.casualTheme.values[key]
        case .fiori:
            return CAITheme.fioriTheme.values[key]
        case .custom(let t, _):
            return t.values[key]
        }
    }

    /// Binds this method in your SwiftUI Views to get the value for the current theme
    /// - Parameter key: Theme.Key
    /// - Parameter Type: Expected Type T that this value should be
    /// - Parameter defaultValue: Default value to return if key does not exist OR is of wrong type
    /// - Returns: Value of type T
    public func value<T>(for key: Theme.Key, type: T.Type, defaultValue: T) -> T {
        if let v = value(for: key) as? T {
            return v
        }
        return defaultValue
    }

    /// Binds this method in your SwiftUI Views to get the value for the current theme
    /// - Parameter key: Theme.Key
    /// - Parameter Type: Expected Type T that this value should be
    /// - Returns: Value of type T?
    public func value<T>(for key: Theme.Key, type: T.Type) -> T? {
        self.value(for: key) as? T
    }

    mutating func setValue<T>(_ value: T, forKey key: Theme.Key) {
        switch self {
        case .casual:
            CAITheme.casualTheme.setValue(value, forKey: key)
        case .fiori:
            assertionFailure("Theme `Fiori` does not allow custom preferences")
        // CAITheme.fioriTheme.setValue(value, forKey: key)
        case .custom(var t, _):
            t.setValue(value, forKey: key)
        }
    }
    
    mutating func updateValues(with newValues: [Theme.Key: Any]) {
        switch self {
        case .casual:
            CAITheme.casualTheme.updateValues(with: newValues)
        case .fiori:
            assertionFailure("Theme `Fiori` does not allow custom preferences")
        // CAITheme.fioriTheme.updateValues(with: newValues)
        case .custom(var t, _):
            t.updateValues(with: newValues)
        }
    }
    
    // MARK: Internal CAI Themes definition
    
    private static var casualTheme = Theme(name: "casual", values: [
        .cornerRadius: CGFloat(16),
        .containerLTPadding: CGFloat(16),
        .incomingTextContainerInset: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
        .outgoingTextContainerInset: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
        .quickReplyButtonStyle: QuickReplyButtonStyleContainer(CasualQuickReplyButtonStyle()),
        .sendButton: "arrow.up.circle.fill",
        .borderWidth: CGFloat(0.33)
    ])
    
    private static var fioriTheme = Theme(name: "fiori", values: [
        .cornerRadius: CGFloat(8),
        .containerLTPadding: CGFloat(16),
        .incomingTextContainerInset: EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0),
        .outgoingTextContainerInset: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
        .quickReplyButtonStyle: QuickReplyButtonStyleContainer(FioriQuickReplyButtonStyle()),
        .sendButton: "arrow.up.square.fill",
        .borderWidth: CGFloat(1)
    ])
}

/// Use this structure to create and implement your own custom theme. Check out Theme.Key enums to know what can be configured.
public struct Theme {
    /// Key
    public let name: String
    
    /// All configurable properties
    var values: [Theme.Key: Any]
    
    /// Set or Update value for key
    /// - Parameter value: Any
    /// - Parameter key: Key
    public mutating func setValue(_ value: Any, forKey key: Theme.Key) {
        self.values[key] = value
    }

    /// Updating all values for keys passed as parameter.
    /// Merging behavior: New keys are added and existing key are overridden with new value
    /// - Parameter newValues: Set of key/value
    public mutating func updateValues(with newValues: [Theme.Key: Any]) {
        self.values.merge(newValues) { _, new in new }
    }

    /// All available key where customization is allowed
    public struct Key: Hashable, RawRepresentable, CustomStringConvertible {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var description: String {
            self.rawValue
        }
        
        /// Corner radius used across the app. Length (aka CGFloat)
        public static let cornerRadius = Key(rawValue: "cornerRadius")
        
        /// Avatar URL for your assistant / bot. String.
        public static let avatarUrl = Key(rawValue: "avatarUrl")
        
        /// Container insets for Text incoming messages. EdgeInsets
        public static let incomingTextContainerInset = Key(rawValue: "incomingTextContainerInset")
        
        /// Container insets for Text outgoing messages. EdgeInsets
        public static let outgoingTextContainerInset = Key(rawValue: "outgoingTextContainerInset")
    
        /// ChatView container leading & trailing padding. Length (aka CGFloat)
        public static let containerLTPadding = Key(rawValue: "containerPadding")
    
        /// `QuickReplyButtonStyleContainer` wrapping a struct/enum conforming to `ButtonStyle`
        public static let quickReplyButtonStyle = Key(rawValue: "quickReplyButtonStyle")
        
        /// Send Button SF Symbol name. String
        public static let sendButton = Key(rawValue: "sendButton")
        
        /// CGFloat
        public static let borderWidth = Key(rawValue: "borderWidth")
    }
    
    /// Used by the color palette
    public enum Color {
        public struct Key: Hashable, RawRepresentable, CustomStringConvertible {
            public var description: String {
                self.rawValue
            }
                        
            public var rawValue: String
            
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            /// Accent color
            public static let accentColor = Key(rawValue: "accentColor")

            /// Background Base color
            public static let backgroundBase = Key(rawValue: "baseBgColor")

            /// Border color
            public static let borderColor = Key(rawValue: "borderColor")

            /// Separator color
            public static let lineColor = Key(rawValue: "lineColor")

            /// Outgoing bubble color
            public static let outgoingBubbleColor = Key(rawValue: "outgoingBubbleColor")

            /// Incoming bubble color
            public static let incomingBubbleColor = Key(rawValue: "incomingBubbleColor")
            
            /// Outgoing text color
            public static let outgoingTextColor = Key(rawValue: "outgoingTextColor")

            /// Incoming text color
            public static let incomingTextColor = Key(rawValue: "incomingTextColor")

            /// Object Background color
            public static let objectBgColor = Key(rawValue: "objectBgColor")
            
            /// Primary1 color
            public static let primary1 = Key(rawValue: "primary1")

            /// Primary2 color
            public static let primary2 = Key(rawValue: "primary2")

            /// Primary5 (secondary background) color
            public static let primary5 = Key(rawValue: "primary5")

            /// Error color
            public static let errorColor = Key(rawValue: "errorColor")

            /// Error color
            public static let errorBannerBorderColor = Key(rawValue: "errorBannerBorderColor")

            /// Input bar background color
            public static let inputBarBGColor = Key(rawValue: "inputBarBGColor")

            /// Shadow color
            public static let shadowColor = Key(rawValue: "shadowColor")

            /// Success color
            public static let successColor = Key(rawValue: "successColor")

            /// Warning color
            public static let warnColor = Key(rawValue: "warnColor")

            /// Information color
            public static let infoColor = Key(rawValue: "infoColor")
        }
    }
}

protocol Themeable {
    var themeableValues: [Theme.Key: Any] { get }
}

/// Implements ObservableObject, Identifiable protocols. Manages available theme and current active one.
///
/// Singleton class, call `ThemeManager.shared` to retrieve it.
/// You can set the active theme by calling `ThemeManager.shared.setCurrentTheme(CAITheme)`
public final class ThemeManager: ObservableObject, Identifiable {
    /// :nodoc:
    public let objectWillChange = PassthroughSubject<CAITheme, Never>()
    
    /// Returns the current active CAITheme
    public private(set) var theme: CAITheme = .fiori(FioriColorPalette())

    /// Singleton instance
    public static let shared = ThemeManager()

    internal init() {}
    
    /// Set active theme. Triggers UI Binding.
    /// - Parameter theme: CAITheme
    public func setCurrentTheme(_ theme: CAITheme) {
        self.theme = theme
        self.objectWillChange.send(theme)
    }
    
    /// Binds this method in your SwiftUI Views to get the color for the current theme
    /// - Parameter key: Theme.Key
    /// - Returns: Color
    public func color(for key: Theme.Color.Key) -> Color {
        self.theme.color(for: key)
    }
    
    /// Binds this method in your SwiftUI Views to get the value for the current theme
    /// - Parameter key: Theme.Key
    /// - Returns: Any. Nil if key is not found
    public func value(for key: Theme.Key) -> Any? {
        self.theme.value(for: key)
    }
    
    /// Binds this method in your SwiftUI Views to get the value for the current theme
    /// - Parameter key: Theme.Key
    /// - Parameter Type: Expected Type T that this value should be
    /// - Parameter defaultValue: Default value to return if key does not exist OR is of wrong type
    /// - Returns: Value of type T
    public func value<T>(for key: Theme.Key, type: T.Type, defaultValue: T) -> T {
        self.theme.value(for: key, type: type, defaultValue: defaultValue)
    }
    
    /// Binds this method in your SwiftUI Views to get the value for the current theme
    /// - Parameter key: Theme.Key
    /// - Parameter Type: Expected Type T that this value should be
    /// - Returns: Value of type T?
    public func value<T>(for key: Theme.Key, type: T.Type) -> T? {
        self.theme.value(for: key, type: type)
    }
    
    func setValue<T>(_ value: T, forKey key: Theme.Key) {
        self.theme.setValue(value, forKey: key)
    }
    
    func updateValues(with newValues: Themeable) {
        self.theme.updateValues(with: newValues.themeableValues)
    }
}
