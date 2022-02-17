import Foundation
import UIKit

// **INTERNAL** extension on UIFont to allow using 72 fonts in UIKit related components

// Those functions are publicly available with SAPFiori.xcframework and therefore will not be added to this project

internal extension UIFont {
    class func preferredFioriFont(forTextStyle textStyle: UIFont.TextStyle, weight: UIFont.Weight = .regular, isItalic: Bool = false, isCondensed: Bool = false) -> UIFont {
        guard var font = UIFont(name: get72FontName(weight: weight.fioriWeight), size: textStyle.size) else {
            var font = UIFont.preferredFont(forTextStyle: textStyle).withWeight(weight)

            if isItalic {
                font = font.italic
            }
//            if isCondensed {
//                font = font.with(.traitCondensed)
//            }

            return font
        }

        let metrics: UIFontMetrics
//        if textStyle == .KPI || textStyle == .largeKPI {
//            metrics = UIFontMetrics(forTextStyle: .largeTitle)
//        } else {
        metrics = UIFontMetrics(forTextStyle: textStyle)
//        }

        if isItalic {
            font = font.italic
        }
//        if isCondensed {
//            font = font.with(.traitCondensed)
//        }

        let scaledFont = metrics.scaledFont(for: font)

        return scaledFont
    }

    class func preferredFioriFont(fixedSize size: CGFloat, weight: UIFont.Weight = .regular, isItalic: Bool = false, isCondensed: Bool = false) -> UIFont {
        guard var font = UIFont(name: get72FontName(weight: weight.fioriWeight), size: size) else {
            var font = UIFont.systemFont(ofSize: size, weight: weight)

            if isItalic {
                font = font.italic
            }
            if isCondensed {
                font = font.with(.traitCondensed)
            }

            return font
        }

        if isItalic {
            font = font.italic
        }
        if isCondensed {
            font = font.with(.traitCondensed)
        }

        return font
    }

    static func get72FontName(weight: UIFont.Weight) -> String {
        let description = weight.description

        // TODO: waiting for designer to update font name in 72-black.ttf
        if weight == .black {
            return "72\(description)"
        }

        return "72-\(description)"
    }
}

private extension UIFont {
    var bold: UIFont {
        self.with(.traitBold)
    }

    var italic: UIFont {
        self.with(.traitItalic)
    }

    var boldItalic: UIFont {
        self.with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}

private extension UIFont.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
//        case .largeKPI:
//            return 48
//        case .KPI:
//            return 36
        default:
            return 17
        }
    }
}

extension UIFont.TextStyle: InternalCustomStringConvertible {
    /// :nodoc:
    var description: String {
        switch self {
        case .largeTitle:
            return "largeTitle"
        case .title1:
            return "title1"
        case .title2:
            return "title2"
        case .title3:
            return "title3"
        case .headline:
            return "headline"
        case .body:
            return "body"
        case .callout:
            return "callout"
        case .subheadline:
            return "subheadline"
        case .footnote:
            return "footnote"
        case .caption1:
            return "caption1"
        case .caption2:
            return "caption2"
//        case .KPI:
//            return "KPI"
//        case .largeKPI:
//            return "largeKPI"
        default:
            return "Unknown"
        }
    }
}

protocol InternalCustomStringConvertible {
    var description: String { get }
}

protocol InternalCaseIterable {
    /// A type that can represent a collection of all values of this type.
    associatedtype AllCases: Collection = [Self] where Self == Self.AllCases.Element

    /// A collection of all values of this type.
    static var allCases: Self.AllCases { get }
}

extension UIFont.Weight: InternalCaseIterable, InternalCustomStringConvertible {
    /// :nodoc:
    static var allCases: [UIFont.Weight] {
        [.black, .heavy, .bold, .semibold, .medium, .regular, .light, .thin, .ultraLight]
    }

    /// :nodoc:
    var description: String {
        let name: String

        switch self {
        case .black:
            name = "black"
        case .heavy:
            name = "heavy"
        case .bold:
            name = "bold"
        case .semibold:
            name = "semibold"
        case .medium:
            name = "medium"
        case .regular:
            name = "regular"
        case .light:
            name = "light"
        case .thin:
            name = "thin"
        case .ultraLight:
            name = "ultraLight"
        default:
            name = "Unknown"
        }

        return name
    }
}

private extension UIFont.Weight {
    // Available 72 weights
    var fioriWeight: UIFont.Weight {
        switch self {
        case .heavy, .black:
            return .black
        case .medium, .semibold, .bold:
            return .bold
        case .regular:
            return .regular
        case .ultraLight, .thin, .light:
            return .light
        default:
            return .regular
        }
    }
}

internal extension UIFontDescriptor {
    class func preferredFioriDescriptor(textStyle: String) -> UIFontDescriptor {
        enum Static {
            static var fontNameTable = [String: String]()
            static var fontSizeTable = [String: [String: Int]]()
            static var fontWeightTable = [String: String]()
        }

        enum KPINumber1Size {
            static let xsmall = Int(42)
            static let small = Int(44)
            static let medium = Int(46)
            static let large = Int(48)
            static let xlarge = Int(50)
            static let xxlarge = Int(52)
            static let xxxlarge = Int(54)
        }

        enum KPINumber2Size {
            static let xsmall = Int(29)
            static let small = Int(31)
            static let medium = Int(33)
            static let large = Int(35)
            static let xlarge = Int(37)
            static let xxlarge = Int(39)
            static let xxxlarge = Int(41)
        }

//        Static.fontSizeTable = [
//            FioriUIFontTextStyle.kpiNumber.rawValue: [UIContentSizeCategory.extraSmall.rawValue: KPINumber1Size.xsmall, UIContentSizeCategory.small.rawValue: KPINumber1Size.small, UIContentSizeCategory.medium.rawValue: KPINumber1Size.medium, UIContentSizeCategory.large.rawValue: KPINumber1Size.large, UIContentSizeCategory.extraLarge.rawValue: KPINumber1Size.xlarge, UIContentSizeCategory.extraExtraLarge.rawValue: KPINumber1Size.xxlarge, UIContentSizeCategory.extraExtraExtraLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityMedium.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityExtraLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraExtraLarge.rawValue: KPINumber1Size.xxxlarge],
//
//            FioriUIFontTextStyle.kpiNumber2.rawValue: [UIContentSizeCategory.extraSmall.rawValue: KPINumber2Size.xsmall, UIContentSizeCategory.small.rawValue: KPINumber2Size.small, UIContentSizeCategory.medium.rawValue: KPINumber2Size.medium, UIContentSizeCategory.large.rawValue: KPINumber2Size.large, UIContentSizeCategory.extraLarge.rawValue: KPINumber2Size.xlarge, UIContentSizeCategory.extraExtraLarge.rawValue: KPINumber2Size.xxlarge, UIContentSizeCategory.extraExtraExtraLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityMedium.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityExtraLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraExtraLarge.rawValue: KPINumber2Size.xxxlarge],
//        ]

//        Static.fontWeightTable = [
//            FioriUIFontTextStyle.kpiNumber.rawValue: "Thin",
//            FioriUIFontTextStyle.kpiNumber2.rawValue: "Light",
//        ]
//
//        Static.fontNameTable = [
//            FioriUIFontTextStyle.kpiNumber.rawValue: "SFUIDisplay",
//            FioriUIFontTextStyle.kpiNumber2.rawValue: "SFUIDisplay"
//        ]

        var contentSize = UIContentSizeCategory.large

        // This is a way to find out if UIApplication is initialized or not for framework unit testing
        // we could get EXC_BAD_ACCESS in calling UIApplication.shared().preferredContentSizeCategory when UIApplication object is not initialized yet
        if UIApplication.shared.description != "" {
            contentSize = UIApplication.shared.preferredContentSizeCategory
        }

        let style = Static.fontSizeTable[textStyle]!
        let fontName = "\(Static.fontNameTable[textStyle]!)-\(Static.fontWeightTable[textStyle]!)"

        return UIFontDescriptor(name: fontName, size: CGFloat(style[contentSize.rawValue]!))
    }
}
