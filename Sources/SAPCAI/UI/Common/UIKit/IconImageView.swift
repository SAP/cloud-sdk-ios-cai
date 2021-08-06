import SwiftUI
struct IconImageView: UIViewRepresentable {
    var iconUrl: String
    
    var iconSize: CGSize
    
    var iconColor: UIColor?

    @Environment(\.colorScheme) var colorScheme

    private var iconColorForColorScheme: UIColor {
        self.colorScheme == .dark ? UIColor.white : UIColor.black
    }

    func makeUIView(context: Context) -> UIImageView {
        let img = UIImage.fromIconUrl(url: self.iconUrl, size: self.iconSize, color: self.iconColor ?? self.iconColorForColorScheme)
        return UIImageView(image: img)
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

#if DEBUG
    struct IconImageView_Previews: PreviewProvider {
        static var previews: some View {
            ForEach(ColorScheme.allCases, id: \.self) {
                ImageView(imageUrl: URL(string: "sap-icon://accept")!)
                    .preferredColorScheme($0)
                    .previewLayout(.fixed(width: 200, height: 200))
            }
        }
    }
#endif
