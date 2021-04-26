import SwiftUI

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
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(text).lineLimit(2).fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(12)
        .animation(Animation.easeIn(duration: 0.3))
        .transition(.move(edge: .top))
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { _ in
            ZStack(alignment: .top) {
                BannerView("some Error")
                    .background(ThemeManager.shared.color(for: .errorColor))
                    .zIndex(1)
            }
        }
    }
}
