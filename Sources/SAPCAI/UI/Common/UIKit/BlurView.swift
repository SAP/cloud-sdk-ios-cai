import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = self.blurEffect(for: context.environment.colorScheme)
        return UIVisualEffectView(effect: effect)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        let effect = self.blurEffect(for: context.environment.colorScheme)
        uiView.effect = effect
    }

    private func blurEffect(for colorScheme: ColorScheme) -> UIBlurEffect {
        UIBlurEffect(style: colorScheme == .light ? .systemThinMaterial : .systemThinMaterialDark)
    }
}
