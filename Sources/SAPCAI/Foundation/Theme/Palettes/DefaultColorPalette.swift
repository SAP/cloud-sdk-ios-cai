import SwiftUI

/// Default Color Palette
/// Using Apple's default color
public struct DefaultColorPalette: ColorPalette {
    public var name: String {
        "Apple"
    }

    public init() {}

    public func color(for key: Theme.Color.Key) -> Color {
        let actualKey = "default_\(key)"
        return Color(actualKey, bundle: Bundle.cai)
    }
}
