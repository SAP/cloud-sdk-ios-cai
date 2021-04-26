import SwiftUI

struct BoundingBox {
    var minWidth: CGFloat = 0
    var minHeight: CGFloat = 0
    
    var maxWidth: CGFloat = 800
    var maxHeight: CGFloat = 600
}

/// SwiftUI View
/// Convert a size to fit into some bounding.
struct SizeConverter<Content>: View where Content: View {
    private var content: (CGSize) -> Content
            
    private var size: CGSize
    
    private var boundingBox: BoundingBox
    
    /// Constructor
    /// - Parameter size: Original size
    /// - Parameter box: BoundingBox
    /// - Parameter content: Content
    init(_ size: CGSize, _ box: BoundingBox, @ViewBuilder content: @escaping (CGSize) -> Content) {
        self.content = content
        self.boundingBox = box
        self.size = size
    }
    
    /// :nodoc:
    var body: some View {
        let targetSize = SizeConverter.applySizeConstraints(from: self.size, to: self.boundingBox)
        
        return content(targetSize)
    }
    
    /// Convert input size to output size according to the bounding box
    /// - Parameters:
    ///   - size: CGSize
    ///   - box: BoundingBox
    static func applySizeConstraints(from size: CGSize, to box: BoundingBox) -> CGSize {
        let minWidth = box.minWidth
        let minHeight = box.minHeight
        let maxWidth = box.maxWidth
        let maxHeight = box.maxHeight
        
        guard size.width > 0 && size.height > 0 else {
            assertionFailure("size is zero")
            return size
        }
        
        // all sides in range
        if size.width >= minWidth && size.width <= maxWidth
            && size.height >= minHeight && size.height <= maxHeight
        {
            return size
        }
        // only width in range
        else if size.width >= minWidth && size.width <= maxWidth {
            if size.height < minHeight {
                return CGSize(width: min(maxWidth, size.width * (minHeight / size.height)), height: minHeight)
            } else if size.height > maxHeight {
                return CGSize(width: max(minWidth, size.width * (maxHeight / size.height)), height: maxHeight)
            }
        }
        // only height in range
        else if size.height >= minHeight && size.height <= maxHeight {
            if size.width < minWidth {
                return CGSize(width: minWidth, height: min(maxHeight, size.height * (minWidth / size.width)))
            } else if size.width > maxWidth {
                return CGSize(width: maxWidth, height: max(minHeight, size.height * (maxWidth / size.width)))
            }
        }
        
        // then no sides are in range
            
        else if size.width < minWidth && size.height > maxHeight {
            return CGSize(width: minWidth, height: maxHeight)
        } else if size.width > maxWidth && size.height < minHeight {
            return CGSize(width: maxWidth, height: minHeight)
        }

        // probably the most common use case, both sides are too large
        else if size.width > maxWidth && size.height > maxHeight {
            let r = max(size.width / maxWidth, size.height / maxHeight)
            return CGSize(width: size.width / r, height: size.height / r)
        }
            
        // both sides are too small
        else if size.width < minWidth && size.height < minHeight {
            let r = min(size.width / minWidth, size.height / minHeight)
            return CGSize(width: size.width / r, height: size.height / r)
        }
        
        assertionFailure("it should never end up here, check conditions.")
        return size
    }
}
