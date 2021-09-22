import SwiftUI

extension UIApplication {
    var mainWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { scene -> Bool in
                scene.activationState == .foregroundActive && scene is UIWindowScene
            }) as? UIWindowScene
        else {
            return nil
        }
        
        return scene.windows.first(where: { $0.isKeyWindow })
    }
}

extension EdgeInsets {
    static let all10 = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    
    var toUIEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: self.top, left: self.leading, bottom: self.bottom, right: self.trailing)
    }
}

extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
        case ..<min: return min
        case max...: return max
        default: return self
        }
    }
}
