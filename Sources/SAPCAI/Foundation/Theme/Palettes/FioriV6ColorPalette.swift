import FioriSwiftUICore
import FioriThemeManager
import SwiftUI

/// Fiori Color Palette (using V6 Color Palette of FioriSwiftUI)
public struct FioriV6ColorPalette: ColorPalette {
    public var name: String {
        "FioriV6ColorPalette"
    }

    public init() {}

    public func color(for key: Theme.Color.Key) -> Color {
        switch key {
        case .accentColor:
            return Color.preferredColor(.tintColor)
        case .backgroundBase:
            return Color.preferredColor(.primaryBackground)
        case .borderColor:
            return Color.preferredColor(.separator)
        case .lineColor:
            return Color.preferredColor(.separator)
        case .outgoingBubbleColor:
            return Color.preferredColor(.informationBackground)
        case .incomingBubbleColor:
            return Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
        case .outgoingTextColor:
            return Color.preferredColor(.primaryLabel)
        case .incomingTextColor:
            return Color.preferredColor(.primaryLabel)
        case .objectBgColor:
            return Color.preferredColor(.secondaryGroupedBackground)
        case .primary1:
            return Color.preferredColor(.primaryLabel)
        case .primary2:
            return Color.preferredColor(.secondaryLabel)
        case .primary5:
            return Color.preferredColor(.tertiaryLabel)
        case .errorColor:
            return Color.preferredColor(.negativeLabel)
        case .errorBannerBorderColor:
            return Color.preferredColor(.negativeBackground)
        case .inputBarBGColor:
            return Color.preferredColor(.secondaryFill)
        case .shadowColor:
            return Color.preferredColor(.cardShadow)
        case .successColor:
            return Color.preferredColor(.positiveLabel)
        case .warnColor:
            return Color.preferredColor(.criticalLabel)
        case .infoColor:
            return Color.preferredColor(.tintColor)
        default:
            let actualKey = "fiori_\(key)"
            let color = Color(actualKey, bundle: Bundle.cai)
            DispatchQueue.main.async {
                print(color.toHex())
            }
            return Color(actualKey, bundle: Bundle.cai)
        }
    }
}

public struct FioriV6ColorPaletteView: View {
    public init() {}

    var colorKeys: [Theme.Color.Key] = [
        .accentColor,
        .backgroundBase,
        .borderColor,
        .lineColor, /// Separator color
        .outgoingBubbleColor,
        .incomingBubbleColor,
        .outgoingTextColor,
        .incomingTextColor,
        .objectBgColor,
        .primary1,
        .primary2,
        .primary5,
        .errorColor,
        .errorBannerBorderColor,
        .inputBarBGColor,
        .shadowColor,
        .successColor,
        .warnColor,
        .infoColor
    ]
    public var body: some View {
        ScrollView {
            Text("CAI").font(Font.fiori(forTextStyle: .largeTitle))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(colorKeys, id: \.self) { colorKey in
                    HStack {
                        VStack {
                            Text(colorKey.rawValue)
                            Text(FioriColorPalette().color(for: colorKey).toHex() ?? "N/A")
                        }
                        Rectangle()
                            .fill(FioriColorPalette().color(for: colorKey))
                            .frame(width: 100, height: 100)
                    }
                    .padding()
                    .frame(width: 320, height: 100, alignment: .trailing)
                    .border(.black)
                }
            }
            Text("Fiori").font(Font.fiori(forTextStyle: .largeTitle))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(ColorStyle.allCases, id: \.self) { colorStyle in
                    HStack {
                        Text(colorStyle.rawValue)
                        Rectangle()
                            .fill(Color.preferredColor(colorStyle))
                            .frame(width: 100, height: 100)
                    }
                    .padding()
                    .frame(width: 320, height: 100, alignment: .trailing)
                    .border(.black)
                }
            }
            //            HStack {
            //                VStack(alignment: .leading) {
            //                    Text("CAI")
            //                    ForEach(colorKeys, id: \.self) { colorKey in
            //                        HStack {
            //                            Text(colorKey.rawValue)
            //                            Rectangle()
            //                                .fill(FioriColorPalette().color(for: colorKey))
            //                                .frame(width: 100, height: 100)
            //                        }
            //                        .padding()
            //                        .border(.red)
            //                    }
            //                }
            //                VStack(alignment: .leading) {
            //                    Text("Fiori iOS")
            //                    ForEach(ColorStyle.allCases, id: \.self) { colorStyle in
            //                        HStack {
            //                            Text(colorStyle.rawValue)
            //                            Rectangle()
            //                                .fill(Color.preferredColor(colorStyle))
            //                                .frame(width: 100, height: 100)
            //                        }
            //                        .padding()
            //                        .border(.red)
            //                    }
            //                }
            //            }
        }
    }
}

struct FioriV6ColorPaletteView_Preview: PreviewProvider {
    static var previews: some View {
        FioriV6ColorPaletteView()
    }
}

// Inspired by https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swift
extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
