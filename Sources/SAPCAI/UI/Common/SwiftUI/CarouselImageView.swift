import SwiftUI

struct CarouselImageView: View {
    var media: MediaItem?
    
    var itemWidth: CGFloat
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if let mediaItem = media, let sourceUrl = mediaItem.sourceUrl {
                if sourceUrl.isSAPIcon == true {
                    VStack(alignment: .leading, spacing: 0) {
                        ImageView(imageUrl: sourceUrl)
                            .frame(width: 50, height: 50)
                            .padding([.leading, .top])
                    }
                    .frame(width: self.itemWidth, alignment: .leading)
                } else {
                    ImageViewWrapper(url: sourceUrl,
                                     placeholder: { mediaItem.placeholder },
                                     failure: { Text($0.localizedDescription) },
                                     content: { $0 })
                        .scaledToFill()
                        .frame(width: self.itemWidth, height: self.vSizeClass == .regular ? 180 : 80)
                        .clipped()
                }
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
