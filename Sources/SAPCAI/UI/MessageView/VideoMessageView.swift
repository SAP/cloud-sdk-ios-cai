import SwiftUI

struct VideoMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let model: MessageData
       
    var media: MediaItem? {
        if case .video(let data) = self.model.type {
            return data
        }
        return nil
    }
    
    let geometry: GeometryProxy
    
    private var targetHeight: CGFloat {
        let ratio = self.geometry.size.width / self.media!.size.width
        return ratio * self.media!.size.height
    }
    
    var body: some View {
        VideoView(self.media?.sourceUrl?.absoluteString)
            .clipShape(RoundedRectangle(cornerRadius: self.themeManager.theme.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 10)))
            .frame(height: targetHeight)
        // !!!!!
        // Calling GeometryReader within ScrollView mess up the rendering as content view is called via closure
//        GeometryReader { geometry in
//            SizeConverter(geometry: geometry, size: self.media?.size) { newSize in
//                VideoView(self.media?.sourceUrl?.absoluteString).frame(width: newSize.width, height: newSize.height)
//            }
//        }
    }
}

#if DEBUG
    struct VideoMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                VideoMessageView(model: testData.model[1], geometry: geometry).environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
