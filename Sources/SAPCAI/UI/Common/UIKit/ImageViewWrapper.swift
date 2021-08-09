import SDWebImage
import SwiftUI

class ImageManager: ObservableObject {
    enum ImageState: Equatable {
        case initial
        case error
        case completed(image: UIImage)
    }
    
    @Published var state: ImageState = .initial
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var box: BoundingBox?
    var placeholder: Image?
    var errorImage: Image?

    var imgSize: CGSize {
        switch self.state {
        case .completed(image: let image):
            return image.size
        case .initial, .error:
            return .zero
        }
    }
}

struct ImageViewWrapper<Content>: View where Content: View {
    @ObservedObject var imageManager: ImageManager
    
    let url: URL?
    let imageView: ImageViewRepresentable
    let content: (_ imgView: ImageViewRepresentable) -> Content

    init(url: URL?,
         @ViewBuilder content: @escaping (_ imgView: ImageViewRepresentable) -> Content)
    {
        self.init(url: url, content: content, manager: ImageManager())
    }
    
    private init(url: URL?,
                 @ViewBuilder content: @escaping (_ imgView: ImageViewRepresentable) -> Content,
                 manager: ImageManager)
    {
        self.url = url
        self.content = content
        self.imageManager = manager
        self.imageView = ImageViewRepresentable(url: url, imageManager: manager)
        self.imageView.loadImage()
    }
    
    var body: some View {
        ZStack {
            switch imageManager.state {
            case .initial:
                if let placeholder = imageManager.placeholder {
                    placeholder
                } else {
                    EmptyView()
                }
            case .completed(image: _):
                content(imageView)
            case .error:
                if let errorImage = imageManager.errorImage {
                    errorImage
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    func scaledToFit() -> Self {
        self.imageManager.contentMode = .scaleAspectFit
        return self
    }

    func scaledToFill() -> Self {
        self.imageManager.contentMode = .scaleAspectFill
        return self
    }
    
    func sizeInto(box: BoundingBox) -> Self {
        self.imageManager.box = box
        return self
    }
    
    func placeholder(_ placeholder: Image) -> Self {
        self.imageManager.placeholder = placeholder
        return self
    }
    
    func errorImage(_ errorImage: Image) -> Self {
        self.imageManager.errorImage = errorImage
        return self
    }
}

struct ImageViewRepresentable: UIViewRepresentable {
    var url: URL?
    var imageManager: ImageManager
    let wrapper = UIImageViewWrapper()

    func makeUIView(context: Self.Context) -> UIImageViewWrapper {
        self.wrapper
    }

    func updateUIView(_ uiView: UIImageViewWrapper, context: UIViewRepresentableContext<ImageViewRepresentable>) {
        uiView.imageView.contentMode = self.imageManager.contentMode
        /// retry strategy missed
        if uiView.imageView.image == nil, self.imageManager.state != .error {
            self.loadImage()
        }
    }
    
    func loadImage() {
        self.wrapper.imageView.sd_setImage(with: self.url,
                                           placeholderImage: nil) { image, error, _, _ in
            if error == nil, let image = image {
                imageManager.state = .completed(image: image)
            } else {
                imageManager.state = .error
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

extension UIView {
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}
