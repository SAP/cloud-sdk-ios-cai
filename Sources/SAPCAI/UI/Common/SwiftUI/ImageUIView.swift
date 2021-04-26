import SwiftUI
import URLImage

/// Renders an image from a MediaItem data model
///
/// Size of the container for the rendering is computed
/// inside this view following these rules:
///  - Min Width: 44
///  - Min Height: 44
///  - Max Width: regular size class: 480, compact size class: geometry width * 0.75
///  - Max Height: regular size class: 400, compact size class: 240
struct ImageUIView: View {
    private let geometry: GeometryProxy
    
    private let media: MediaItem?
    
    @Environment(\.horizontalSizeClass) private var hSizeClass

    @Environment(\.verticalSizeClass) private var vSizeClass
    
    private let fallback: Image
    
    /// Constructor
    /// - Parameters:
    ///   - geometry: GeometryProxy in which the image will be rendered. Only the width is used.
    ///   - media: MediaItem
    ///   - fallback: Fallback image used if media.sourceUrl is nil.
    init(geometry: GeometryProxy,
         media: MediaItem?,
         fallback: Image = Image(systemName: "icloud.slash"))
    {
        self.media = media
        self.geometry = geometry
        self.fallback = fallback
    }
    
    // :nodoc:
    var body: some View {
        Group {
            if let sourceUrl = media?.sourceUrl {
                URLImage(url: sourceUrl) { image, info in
                    SizeConverter(
                        CGSize(width: CGFloat(info.cgImage.width), height: CGFloat(info.cgImage.height)),
                        BoundingBox(minWidth: 44,
                                    minHeight: 44,
                                    maxWidth: self.hSizeClass == .regular ? 480 : self.geometry.size.width * 0.75,
                                    maxHeight: self.vSizeClass == .regular ? 400 : 240),
                        content: { targetSize in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: targetSize.width, height: targetSize.height)
                        }
                    )
                    .preference(key: ImageSizeInfoPrefKey.self,
                                value: CGSize(width: info.cgImage.width,
                                              height: info.cgImage.height))
                }
            } else {
                fallback
            }
        }
    }
}

struct ImageSizeInfoPrefKey: PreferenceKey {
    typealias Value = CGSize

    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ImageUIView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ImageUIView(geometry: geometry, media: nil)
        }
    }
}
