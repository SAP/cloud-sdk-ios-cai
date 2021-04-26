import CoreText
import UIKit

// MARK: - Public

public enum SAPFontName: String {
    case icon = "SAP-icons"
}

/// A SAP Icon extension to UIFont.
public extension UIFont {
    /// Get a UIFont object of SAP Icon.
    ///
    /// - parameter name: SAP font name.
    /// - parameter ofSize: The preferred font size.
    /// - returns: A UIFont object of SAP Icon.
    class func from(name: SAPFontName, ofSize fontSize: CGFloat) -> UIFont {
        let sName = name.rawValue
        if UIFont.fontNames(forFamilyName: sName).isEmpty {
            FontLoader.loadFont(sName)
        }
        
        return UIFont(name: sName, size: fontSize)!
    }
}

/// A SAP Icon extension to String.
public extension String {
    /// Get a SAP Icon icon string with the given icon name.
    ///
    /// - parameter name: The preferred icon name.
    /// - returns: A string that will appear as icon with SAP Icon.
    static func fromIcon(_ name: SAPIcon) -> String {
        let idx = name.rawValue.index(name.rawValue.startIndex, offsetBy: 1)
        return String(name.rawValue[..<idx])
    }
    
    /// Get a SAP Icon icon string with the given CSS icon code.
    ///
    /// - parameter code: The preferred icon name.
    /// - returns: A string that will appear as icon with SAP Icon.
    static func fromIcon(code: String) -> String? {
        guard let name = SAPIcon.fromCode(code) else {
            return nil
        }

        return self.fromIcon(name)
    }
}

/// A SAP Icon extension to UIImage.
public extension UIImage {
    /// Get a SAP Icon image with the given url, size and icon color.
    ///
    /// - parameter url: The image url.
    /// - parameter size: The image size.
    /// - parameter color: The icon color.
    /// - returns: An image that will appear as icon with SAP Icon
    static func fromIconUrl(url: String, size: CGSize = CGSize(width: 50, height: 50), color: UIColor?) -> UIImage? {
        var imgUrl = url
        
        if imgUrl.range(of: "sap-icon") != nil {
            let range = imgUrl.rangeOfCharacter(from: CharacterSet(charactersIn: "/"), options: String.CompareOptions.backwards)
            imgUrl = String(imgUrl[range!.upperBound...])
            
            let fontName = SAPFontName.icon
            return UIImage.fromIconFont(fontName, imgUrl, color ?? UIColor.black, size)
        }
                        
        return nil
    }

    /// Get a SAP Icon image with the given icon name, text color, size and an optional background color.
    ///
    /// - parameter name: The preferred icon name.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: An image that will appear as icon with SAP Icon
    static func fromIcon(_ name: SAPIcon,
                         _ textColor: UIColor,
                         _ size: CGSize,
                         _ backgroundColor: UIColor = UIColor.clear) -> UIImage
    {
        self.sapIconFontIcon(fontName: .icon, value: String.fromIcon(name), textColor: textColor, size: size)
    }
    
    /// Get a SAP Icon image with the given icon css code, text color, size and an optional background color.
    ///
    /// - parameter fontName: SAP font name.
    /// - parameter code: The preferred icon css code.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: An image that will appear as icon with SAP Icon
    static func fromIconFont(_ fontName: SAPFontName,
                             _ code: String,
                             _ textColor: UIColor,
                             _ size: CGSize,
                             _ backgroundColor: UIColor = UIColor.clear) -> UIImage?
    {
        switch fontName {
        case .icon:
            guard let name = SAPIcon.fromCode(code) else { return nil }
            return self.fromIcon(name, textColor, size, backgroundColor)
        }
    }
    
    private static func sapIconFontIcon(fontName: SAPFontName,
                                        value: String,
                                        textColor: UIColor,
                                        size: CGSize,
                                        backgroundColor: UIColor = UIColor.clear) -> UIImage
    {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontAspectRatio: CGFloat = 1.2
        
        let fontSize: CGFloat = min(size.width / fontAspectRatio, size.height)
        let attributedString = NSAttributedString(string: value,
                                                  attributes: [NSAttributedString.Key.font: UIFont.from(name: fontName, ofSize: fontSize),
                                                               NSAttributedString.Key.foregroundColor: textColor,
                                                               NSAttributedString.Key.backgroundColor: backgroundColor,
                                                               NSAttributedString.Key.paragraphStyle: paragraph])
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - Private

private class FontLoader {
    // swiftlint:disable force_try
    class func loadFont(_ name: String) {
        #if SWIFT_PACKAGE
            let bundle = Bundle.module
        #else
            let bundle = Bundle(for: FontLoader.self)
        #endif

        let fontURL = bundle.url(forResource: name, withExtension: "ttf")!

        let data = try! Data(contentsOf: fontURL)

        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font!, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as? NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError!]).raise()
        }
    }
}
