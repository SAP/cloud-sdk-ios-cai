import SwiftUI
import URLImage

struct CarouselImageView: View {
    var media: MediaItem?
    
    var itemWidth: CGFloat
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if let mediaItem = media, let sourceUrl = mediaItem.sourceUrl {
                URLImage(sourceUrl,
                         inProgress: { _ -> Image in
                             mediaItem.placeholder
                         },
                         failure: { error, _ in
                             Text(error.localizedDescription)
                         },
                         content: { image in
                             image
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                         })
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
