import FioriThemeManager
import SAPCAI
import SwiftUI

struct ThemingView: View {
    static var colorKeys: [Theme.Color.Key] = [
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

    @StateObject var colorPalette = CustomColorPalette(keys: ThemingView.colorKeys)

    var body: some View {
        ScrollView {
//            HStack {
//                Button("Apply") {
//                    SAPCAI.ThemeManager.shared.setCurrentTheme(.fiori(colorPalette))
//                }
//                Button("Reset") {
//                    ThemeManager.shared.setCurrentTheme(.fiori(FioriColorPalette()))
//                    colorPalette.colorDic.keys.forEach { colorPalette.reset(key: $0) }
//                }
//            }
            ForEach(Array(colorPalette.colorDic.keys.sorted { $0.rawValue < $1.rawValue }), id: \.self) { colorKey in
                HStack {
                    VStack(alignment: .trailing) {
                        Text(colorKey.rawValue)
                        Text(colorPalette.color(for: colorKey).toHex() ?? "N/A")
                    }
                    Rectangle()
                        .fill(colorPalette.color(for: colorKey))
                        .frame(width: 100, height: 100)
                    // NavigationLink("Change Color", destination: ColorPicker(colorKey: colorKey, colorPalette: colorPalette))
                }
                .padding()
                .frame(width: 320, height: 100, alignment: .trailing)
                // .border(.black)
            }
        }
    }
}

struct ColorPicker: View {
    var colorKey: Theme.Color.Key
    @ObservedObject var colorPalette: CustomColorPalette
    @State private var suggestedColor: ColorStyle?
    var body: some View {
        VStack {
            Picker("Flavor", selection: $suggestedColor) {
                Text("Nothing").tag(nil as ColorStyle?)
                ForEach(ColorStyle.allCases, id: \.self) { colorStyle in
                    Text(colorStyle.rawValue)
                        .tag(colorStyle as ColorStyle?)
                }
            }
            .onChange(of: suggestedColor) { newValue in
                if let colorStyle = newValue {
                    colorPalette.setColor(Color.preferredColor(colorStyle), for: colorKey)
                } else {
                    colorPalette.reset(key: colorKey)
                }
            }
            .pickerStyle(.wheel)
        }
    }
}

struct ThemingView_Previews: PreviewProvider {
    static var previews: some View {
        ThemingView()
    }
}

class CustomColorPalette: ObservableObject, ColorPalette {
    @Published var colorDic: [Theme.Color.Key: Color] = [:]

    init(keys: [Theme.Color.Key]) {
        for key in keys {
            self.colorDic[key] = self.color(for: key)
        }
    }

    var name: String {
        "Custom"
    }

    func setColor(_ color: Color, for key: Theme.Color.Key) {
        self.colorDic[key] = color
    }

    func reset(key: Theme.Color.Key) {
        self.colorDic.removeValue(forKey: key)
    }

    func color(for key: Theme.Color.Key) -> Color {
        if let color = colorDic[key] {
            return color
        } else {
            return ThemeManager.shared.color(for: key)
        }
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
