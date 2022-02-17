import Down
import SwiftUI

/**
   Type-erased container to be used when setting own QuickReply button style
   If you wish to create your own QuickReply button style, do so by conforming to `ButtonStyle`, put it into `QuickReplyButtonStyleContainer`
   and use `Theme.Key` enum `quickReplyButtonStyle()` to apply it.

   ## Example: define style
   ```swift

   public struct MyCustomQuickReplyButtonStyle: ButtonStyle {
       public func makeBody(configuration: MyCustomQuickReplyButtonStyle.Configuration) -> AnyView {

           return AnyView(
               configuration.label
                   .font(Font.fiori(forTextStyle: .body))
                   .lineLimit(1)
                   .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
           )
       }
   }
  ```

  ## Example: apply style

   ```swift
   Theme(name: "myCustomTheme", values: [
       .quickReplyButtonStyle: QuickReplyButtonStyleContainer(MyCustomQuickReplyButtonStyle())
   ])
   ```
 */
public struct QuickReplyButtonStyleContainer: ButtonStyle {
    let view: (ButtonStyleConfiguration) -> AnyView

    init<S: ButtonStyle>(_ style: S) {
        self.view = {
            AnyView(style.makeBody(configuration: $0))
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        self.view(configuration)
    }
}

/// QuickReply button style applied when using custom theme and no specific button style was provided
public struct BaseQuickReplyButtonStyle: ButtonStyle {
    public func makeBody(configuration: BaseQuickReplyButtonStyle.Configuration) -> AnyView {
        AnyView(configuration.label)
    }
}

/// QuickReply button style applied when using Fiori theme
public struct FioriQuickReplyButtonStyle: ButtonStyle {
    var radius: CGFloat {
        22
    }

    public func makeBody(configuration: FioriQuickReplyButtonStyle.Configuration) -> AnyView {
        AnyView(
            configuration.label
                .font(Font.fiori(forTextStyle: .body))
                .lineLimit(1)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                .background(configuration.isPressed ? Color.accentColor : Color.clear)
                .foregroundColor(configuration.isPressed ? Color.white : Color.accentColor)
                .overlay(RoundedRectangle(cornerRadius: self.radius).stroke(Color.accentColor, lineWidth: 1))
                .cornerRadius(self.radius)
        )
    }
}

/// QuickReply button style applied when using Casual theme
public struct CasualQuickReplyButtonStyle: ButtonStyle {
    public func makeBody(configuration: FioriQuickReplyButtonStyle.Configuration) -> AnyView {
        var radius: CGFloat {
            22
        }

        return AnyView(
            configuration.label
                .font(Font.fiori(forTextStyle: .body))
                .lineLimit(1)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                .background(configuration.isPressed ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3))
                .foregroundColor(configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor)
                .cornerRadius(radius)
        )
    }
}

/**
   Type-erased container to be used when setting own rounded corner button style (used in list items)
   If you wish to create your own RoundedCorner button style, do so by conforming to `ButtonStyle`, put it into `RoundedCornerButtonStyleContainer`
   and use `Theme.Key` enum `roundedCornerButtonStyle()` to apply it.

   ## Example: define style
   ```swift

   public struct MyCustomRoundedCornerButtonStyle: ButtonStyle {
       public func makeBody(configuration: MyCustomRoundedCornerButtonStyle.Configuration) -> AnyView {

           return AnyView(
               configuration.label
                   .font(Font.fiori(forTextStyle: .body))
                   .lineLimit(1)
                   .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
           )
       }
   }
  ```

  ## Example: apply style

   ```swift
   Theme(name: "myCustomTheme", values: [
       .cardListButtonStyle: CardListButtonStyleContainer(MyCustomCardListButtonStyle())
   ])
   ```
 */
public struct RoundedCornerButtonStyleContainer: ButtonStyle {
    let view: (ButtonStyleConfiguration) -> AnyView

    init<S: ButtonStyle>(_ style: S) {
        self.view = {
            AnyView(style.makeBody(configuration: $0))
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        self.view(configuration)
    }
}

/// RoundedCorner button style applied when using custom theme and no specific button style was provided
public struct BaseRoundedCornerButtonStyle: ButtonStyle {
    public func makeBody(configuration: BaseRoundedCornerButtonStyle.Configuration) -> AnyView {
        AnyView(configuration.label)
    }
}

/// RoundedCorner button style applied when using Fiori theme
public struct FioriRoundedCornerButtonStyle: ButtonStyle {
    var radius: CGFloat {
        10
    }

    public func makeBody(configuration: FioriRoundedCornerButtonStyle.Configuration) -> AnyView {
        AnyView(
            configuration.label
                .font(Font.fiori(forTextStyle: .body))
                .lineLimit(1)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                .background(configuration.isPressed ? Color.accentColor : Color.clear)
                .foregroundColor(configuration.isPressed ? Color.white : Color.accentColor)
                .overlay(RoundedRectangle(cornerRadius: self.radius).stroke(Color.accentColor, lineWidth: 1))
                .cornerRadius(self.radius)
        )
    }
}

/// RoundedCorner button style applied when using Casual theme
public struct CasualRoundedCornerButtonStyle: ButtonStyle {
    public func makeBody(configuration: CasualRoundedCornerButtonStyle.Configuration) -> AnyView {
        var radius: CGFloat {
            10
        }

        return AnyView(
            configuration.label
                .font(Font.fiori(forTextStyle: .body))
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
    var heading1: DownFont = .preferredFioriFont(fixedSize: 28, weight: .bold)

    var heading2: DownFont = .preferredFioriFont(fixedSize: 25, weight: .bold)

    var heading3: DownFont = .preferredFioriFont(fixedSize: 22, weight: .bold)

    var heading4: DownFont = .preferredFioriFont(fixedSize: 19, weight: .bold)

    var heading5: DownFont = .preferredFioriFont(fixedSize: 16, weight: .bold)

    var heading6: DownFont = .preferredFioriFont(fixedSize: 13, weight: .bold)

    var body = DownFont.preferredFioriFont(forTextStyle: .body)

    var code = DownFont(name: "menlo", size: 17) ?? .preferredFioriFont(fixedSize: 17)

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
