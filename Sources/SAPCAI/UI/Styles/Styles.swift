import Down
import SwiftUI

/// Base Button Style for Quick Reply buttons
/// If you wish to create your own QuickReply button style, do so by extending
/// this class and override `makeBody()` method.
open class BaseQuickReplyButtonStyle: ButtonStyle {
    open func makeBody(configuration: BaseQuickReplyButtonStyle.Configuration) -> AnyView {
        AnyView(configuration.label)
    }
}

/// Fiori Design Langauge implementation for QuickReply button
public final class FioriQuickReplyButtonStyle: BaseQuickReplyButtonStyle {
//    var theme: CAITheme
    
    var radius: CGFloat {
        8
    }
    
    override public func makeBody(configuration: FioriQuickReplyButtonStyle.Configuration) -> AnyView {
        AnyView(
            configuration.label
                .font(.body)
                .lineLimit(1)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                .background(configuration.isPressed ? Color.accentColor : Color.clear)
                .foregroundColor(configuration.isPressed ? Color.white : Color.accentColor)
                .overlay(RoundedRectangle(cornerRadius: self.radius).stroke(Color.accentColor, lineWidth: 1))
                .cornerRadius(self.radius)
        )
    }
    
//    init() {}
//    init(_ theme: CAITheme) {
//        self.theme = theme
//    }
}

public final class DefaultQuickReplyButtonStyle: BaseQuickReplyButtonStyle {
    override public func makeBody(configuration: FioriQuickReplyButtonStyle.Configuration) -> AnyView {
        var radius: CGFloat {
            22
        }
        
        return AnyView(
            configuration.label
                .font(.body)
                .lineLimit(1)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                .background(configuration.isPressed ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3))
                .foregroundColor(configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor)
                .cornerRadius(radius)
        )
    }
}

/// :nodoc:
struct CAIFontCollection: FontCollection {
    // change font
    var heading1: DownFont = .boldSystemFont(ofSize: 28)

    var heading2: DownFont = .boldSystemFont(ofSize: 25)

    var heading3: DownFont = .boldSystemFont(ofSize: 22)

    var heading4: DownFont = .boldSystemFont(ofSize: 19)

    var heading5: DownFont = .boldSystemFont(ofSize: 16)

    var heading6: DownFont = .boldSystemFont(ofSize: 13)

    var body = DownFont.preferredFont(forTextStyle: .body)

    var code = DownFont(name: "menlo", size: 17) ?? .systemFont(ofSize: 17)

    var listItemPrefix = DownFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)
    
    init() {}
}

/// :nodoc:
struct CAIColorCollection: ColorCollection {
    // change colors
    var heading1: DownColor = .label

    var heading2: DownColor = .secondaryLabel

    var heading3: DownColor = .systemGray2

    var heading4: DownColor = .systemGray2

    var heading5: DownColor = .systemGray2

    var heading6: DownColor = .systemGray2

    var body: DownColor = .label

    var code: DownColor = .black

    var link: DownColor = .link

    var quote: DownColor = .darkGray

    var quoteStripe: DownColor = .darkGray

    var thematicBreak = DownColor(white: 0.9, alpha: 1)

    var listItemPrefix: DownColor = .lightGray

    var codeBlockBackground = DownColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
    
    init() {}
}

/// :nodoc:
struct CAIParagraphStyleCollection: ParagraphStyleCollection {
    var heading1: NSParagraphStyle = .default

    var heading2: NSParagraphStyle = .default

    var heading3: NSParagraphStyle = .default

    var heading4: NSParagraphStyle = .default

    var heading5: NSParagraphStyle = .default

    var heading6: NSParagraphStyle = .default

    public var body: NSParagraphStyle {
        let paraphStyle = NSMutableParagraphStyle()
        paraphStyle.setParagraphStyle(.default)
        paraphStyle.lineSpacing = 2
        return paraphStyle
    }

    public var code: NSParagraphStyle = .default

    init() {}
}

/// Default `DownStyler` for Markdown text rendering.
/// :nodoc:
open class CAIStyler: DownStyler {
    public convenience init() {
        var downConfig = DownStylerConfiguration()
        
        // change font fpr body
        downConfig.fonts = CAIFontCollection()
        
        // change line spacing
        downConfig.paragraphStyles = CAIParagraphStyleCollection()

        downConfig.colors = CAIColorCollection()
        
        self.init(configuration: downConfig)
    }
}
