import SwiftUI

struct ImageMessageView: View {
    let model: MessageData
    
    let geometry: GeometryProxy
        
    @EnvironmentObject private var themeManager: ThemeManager
    
    var media: MediaItem? {
        if case .picture(let data) = self.model.type {
            return data
        }
        assertionFailure("Do not use ImageMessageView if type is not `picture`")
        return nil
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ImageUIView(geometry: self.geometry, media: media)
        }
        .clipShape(RoundedRectangle(cornerRadius: self.themeManager.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 10)))
        .background(roundedBorder(cornerRadius: themeManager.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 10),
                                  color: themeManager.color(for: .borderColor)))
    }
}

#if DEBUG
    struct ImageMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                ImageMessageView(model: testData.model[4], geometry: geometry)
            }
        }
    }
#endif

struct ImageMessageDetailView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
    }
}
