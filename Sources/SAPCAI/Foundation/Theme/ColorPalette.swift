import Foundation
import SwiftUI

/// Protocol for ColorPalette.
public protocol ColorPalette {
    var name: String { get }

    /// Returns Color for key
    /// - Parameter key: Theme.Color.Key
    func color(for key: Theme.Color.Key) -> Color

//    func color(for key: Theme.Color.Key, colorScheme: ColorScheme) -> Color
}
