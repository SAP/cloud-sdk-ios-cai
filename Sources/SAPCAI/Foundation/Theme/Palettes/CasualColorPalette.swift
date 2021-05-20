import SwiftUI

/// Casual Color Palette
public struct CasualColorPalette: ColorPalette {
    public var name: String {
        "CasualColorPalette"
    }

    public init() {}

    public func color(for key: Theme.Color.Key) -> Color {
        let actualKey = "default_\(key)"
        return Color(actualKey, bundle: Bundle.cai)
    }
}
