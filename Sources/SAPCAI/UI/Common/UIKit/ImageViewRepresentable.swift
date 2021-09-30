import SDWebImage
import SwiftUI

struct ImageViewRepresentable: UIViewRepresentable {
    var url: URL?
    var imageManager: ImageManager
    let wrapper = UIImageViewWrapper()

    func makeUIView(context: Self.Context) -> UIImageViewWrapper {
        self.wrapper
    }

    func updateUIView(_ uiView: UIImageViewWrapper, context: UIViewRepresentableContext<ImageViewRepresentable>) {
        uiView.imageView.contentMode = self.imageManager.contentMode
        if case ImageManager.ImageState.error = self.imageManager.state, uiView.imageView.image == nil {
            self.loadImage()
        }
    }
    
    func loadImage() {
        self.wrapper.imageView.sd_setImage(with: self.url,
                                           placeholderImage: nil) { image, error, _, _ in
            if let error = error {
                imageManager.state = .error(error)
            } else if let image = image {
                imageManager.state = .completed(image: image)
            } else {
                imageManager.state = .error(NSError(domain: "cai.com", code: 1, userInfo: nil))
            }
        }
    }
}

class UIImageViewWrapper: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.imageView)
        self.imageView.bindFrameToSuperviewBounds()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(self.imageView)
        self.imageView.bindFrameToSuperviewBounds()
    }
}
