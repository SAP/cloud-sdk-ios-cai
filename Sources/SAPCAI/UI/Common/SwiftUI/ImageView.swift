import SwiftUI
import URLImage

/// Renders an image from a MediaItem data model
struct ImageView: View {
    var imageUrl: URL
    
    var body: some View {
        VStack(spacing: 0) {
            if imageUrl.isSAPIcon {
                IconImageView(iconUrl: imageUrl.absoluteString, iconSize: CGSize(width: 50, height: 50))
            } else {
                URLImage(url: imageUrl,
                         failure: { _, _ in
                             Image(systemName: "photo")
                         },
                         content: { image in
                             image
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .cornerRadius(8)
                         })
            }
        }
    }
}

#if DEBUG
    struct ImageView_Previews: PreviewProvider {
        static var previews: some View {
            ForEach(ColorScheme.allCases, id: \.self) {
                ImageView(imageUrl: URL(string: "sap-icon://accept")!)
                    .preferredColorScheme($0)
                    .previewLayout(.fixed(width: 200, height: 200))
                // swiftlint:disable:next line_length
                ImageView(imageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Tango_style_Wikipedia_Icon.svg/1024px-Tango_style_Wikipedia_Icon.svg.png")!)
                    .preferredColorScheme($0)
                    .previewLayout(.fixed(width: 200, height: 200))
            }
        }
    }
#endif
