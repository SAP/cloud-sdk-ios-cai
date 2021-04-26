import SwiftUI
struct IconImageView: UIViewRepresentable {
    var iconUrl: String
    
    var iconSize: CGSize
    
    var iconColor: UIColor?

    func makeUIView(context: Context) -> UIImageView {
        let img = UIImage.fromIconUrl(url: self.iconUrl, size: self.iconSize, color: self.iconColor)
        return UIImageView(image: img)
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}
