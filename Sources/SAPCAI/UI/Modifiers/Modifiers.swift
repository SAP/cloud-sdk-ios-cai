import SwiftUI
import UIKit

func roundedBorder(cornerRadius radius: CGFloat, color: Color, lineWidth: CGFloat = 1) -> some View {
    RoundedRectangle(cornerRadius: radius).stroke(color, lineWidth: lineWidth)
}

func roundedBorder(for theme: CAITheme) -> some View {
    let radius = theme.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 10)
    
    return RoundedRectangle(cornerRadius: radius)
        .fill(theme.color(for: .objectBgColor))
        .shadow(color: theme.color(for: .shadowColor), radius: 8, x: 0, y: 2)
        .overlay(RoundedRectangle(cornerRadius: radius).stroke(theme.color(for: .borderColor), lineWidth: theme.value(for: .borderWidth, type: CGFloat.self, defaultValue: 1)))
}

func roundedBackground(for theme: CAITheme, key: Theme.Color.Key) -> some View {
    RoundedCorner(radius: theme.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 10),
                  corners: [.topLeft, .topRight, .bottomLeft])
        .fill(theme.color(for: key))
}

struct MessageBubbleModifier: ViewModifier {
    let themeManager: ThemeManager
    
    // true if in front (incoming)
    let reversed: Bool
    
    func body(content: Content) -> some View {
        let path = Path { p in
            let origin: CGPoint
            let curveOnePoint: CGPoint
            let curveOneControl: CGPoint
            let curveTwoPoint: CGPoint
            let curveTwoControl: CGPoint
            
            origin = CGPoint(x: 0, y: 0)
            curveOnePoint = CGPoint(x: 16, y: 10)
            curveOneControl = CGPoint(x: -2, y: 8)
            curveTwoPoint = CGPoint(x: 8, y: 0)
            curveTwoControl = CGPoint(x: 10, y: 5)
            
            p.move(to: origin)
            p.addQuadCurve(to: curveOnePoint, control: curveOneControl)
            p.addQuadCurve(to: curveTwoPoint, control: curveTwoControl)
        }
        .scale(x: self.reversed ? -1 : 1, y: 1)
        .fill(self.themeManager.color(for: self.reversed ? .incomingBubbleColor : .outgoingBubbleColor))
        .frame(width: 20, height: 10, alignment: .trailing)
        .offset(x: self.reversed ? -10 : 10, y: 2)
       
        var showTail = false
        switch self.themeManager.theme {
        case .casual:
            showTail = true
        default:
            showTail = false
        }
        let stack = HStack {
            if reversed && showTail {
                path
            }
            Spacer()
            if !reversed && showTail {
                path
            }
        }
        return content.overlay(stack, alignment: .bottom)
    }
}

struct TextWidthModifier: ViewModifier {
    let geometry: GeometryProxy
       
    let isRegular: Bool
    
    let isBot: Bool
    
    func body(content: Content) -> some View {
        content.frame(minWidth: 0,
                      maxWidth: self.isRegular ? 480 : self.geometry.size.width * 0.75,
                      alignment: self.isBot ? .leading : .trailing)
    }
}

extension View {
    func tail(_ themeManager: ThemeManager, reversed: Bool = false) -> some View {
        self.modifier(MessageBubbleModifier(themeManager: themeManager, reversed: reversed))
    }
    
    func textWidth(_ geometry: GeometryProxy, isRegular: Bool = false, isBot: Bool = false) -> some View {
        self.modifier(TextWidthModifier(geometry: geometry, isRegular: isRegular, isBot: isBot))
    }
}
