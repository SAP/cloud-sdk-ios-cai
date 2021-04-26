import Foundation
import UIKit

extension UIColor {
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r, g, b, a)
        }
        return (0, 0, 0, 0)
    }

    var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return (h, s, b, a)
        }
        return (0, 0, 0, 0)
    }

    var hslComponents: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        let rgb = rgbComponents, hsb = hsbComponents
        let maximum = max(rgb.red, rgb.green, rgb.blue)
        let minimum = min(rgb.red, rgb.green, rgb.blue)
        let range = maximum - minimum
        let lightness = (maximum + minimum) / 2.0
        let saturation = range == 0 ? 0 : range / { lightness < 0.5 ? lightness * 2 : 2 - (lightness * 2) }()
        return (hsb.hue, saturation, lightness, hsb.alpha)
    }
}
