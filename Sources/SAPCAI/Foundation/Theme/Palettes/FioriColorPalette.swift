import FioriSwiftUICore
import FioriThemeManager
import SwiftUI

/// Fiori Color Palette. Follows SAP Fiori Design Language.
public struct FioriColorPalette: ColorPalette {
    public var name: String {
        "FioriColorPalette"
    }

    public init() {}

    public func color(for key: Theme.Color.Key) -> Color {
        let actualKey = "fiori_\(key)"
        return Color(actualKey, bundle: Bundle.cai)
    }
}
