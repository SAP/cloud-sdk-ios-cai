import SwiftUI

struct CarouselImageView: View {
    var media: MediaItem?
    
    var itemWidth: CGFloat
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if let mediaItem = media, let sourceUrl = mediaItem.sourceUrl {
                ImageViewWrapper(url: sourceUrl) { $0 }
                    .placeholder(mediaItem.placeholder)
                    .scaledToFill()
                    .frame(width: self.itemWidth, height: self.vSizeClass == .regular ? 180 : 80)
                    .clipped()
            } else {
                Image(systemName: "icloud.slash")
            }
        }
    }
}

struct CarouselImageView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselImageView(media: nil, itemWidth: CGFloat(integerLiteral: 300))
    }
}
