import SwiftUI

/// Type for `BannerView`
public enum BannerViewType {
    /// Banner shows an error
    case error
    /// Banner shows a non-semantical text
    case generic
}

/// Slide down and up a banner view.
/// There is no default background color.
///
/// Example of usage:
///  ```
/// BannerView("Text to display")
///       .onTapGesture {
///           someError = nil
///       }
/// }
/// ```
///
///
public struct BannerView: View {
    private let text: String
    private let type: BannerViewType
    private let closeIndicator: Bool

    private var textForegroundColor: Color {
        switch self.type {
        case .error:
            return ThemeManager.shared.color(for: .errorColor)
        case .generic:
            return ThemeManager.shared.color(for: .primary1)
        }
    }

    private var borderColor: Color {
        switch self.type {
        case .error:
            return ThemeManager.shared.color(for: .errorBannerBorderColor)
        case .generic:
            return .accentColor
        }
    }

    /// Initializer
    /// - Parameters:
    ///   - text: text to display in banner
    ///   - type: type deciding on visual representation details for the banner
    ///   - closeIndicator: image to represent the capability of closing the banner
    public init(_ text: String, type: BannerViewType = .error, closeIndicator: Bool = false) {
        self.text = text
        self.type = type
        self.closeIndicator = closeIndicator
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                Spacer()
                Text(text).lineLimit(2).font(Font.system(size: 13).weight(Font.Weight.medium)).foregroundColor(self.textForegroundColor)
                Spacer()
                if self.closeIndicator {
                    Image(systemName: "xmark").foregroundColor(.gray)
                }
            }
            .padding(12)
            .animation(Animation.easeIn(duration: 0.3))
            .transition(.move(edge: .top))
            .background(BlurView())
            .border(width: 5, edges: [.top], color: borderColor)
            .if(type != .generic) { view in
                view.border(width: 5, edges: [.top], color: borderColor)
            }
        }
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { _ in
                ZStack(alignment: .top) {
                    BannerView("some Error", closeIndicator: true)
                        .zIndex(1)

                    VStack {
                        Text("Background Text")
                        Text("Background Text")
                        Text("Background Text")
                        Text("Background Text")
                        Text("Background Text")
                    }
                }
            }
            .previewLayout(PreviewLayout.sizeThatFits)
            .previewDisplayName("Error Banner - light mode")

            GeometryReader { _ in
                ZStack(alignment: .top) {
                    BannerView("some Info", type: .generic)
                        .zIndex(1)

                    VStack {
                        Text("Background Text")
                        Text("Background Text")
                        Text("Background Text")
                        Text("Background Text")
                        Text("Background Text")
                    }
                }
            }
            .previewLayout(PreviewLayout.sizeThatFits)
            .preferredColorScheme(.dark)
            .previewDisplayName("Generic Banner - dark mode")
        }
    }
}
