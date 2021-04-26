import UIKit

/// A `UIView` subclass that maintains a mask to keep it fully circular
/// :nodoc:
class BubbleCircle: UIView {
    /// Lays out subviews and applys a circular mask to the layer
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.mask = self.roundedMask(corners: .allCorners, radius: bounds.height / 2)
    }
    
    /// Returns a rounded mask of the view
    ///
    /// - Parameters:
    ///   - corners: The corners to round
    ///   - radius: The radius of curve
    /// - Returns: A mask
    func roundedMask(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        return mask
    }
}
