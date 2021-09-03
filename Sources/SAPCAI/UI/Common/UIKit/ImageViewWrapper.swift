import SDWebImage
import SwiftUI

class ImageManager: ObservableObject {
    enum ImageState {
        case initial
        case error(_ error: Error)
        case completed(image: UIImage)
    }
    
    @Published var state: ImageState = .initial
    var contentMode: UIView.ContentMode = .scaleAspectFit

    var imgSize: CGSize {
        switch self.state {
        case .completed(image: let image):
            return image.size
        case .initial, .error:
            return .zero
        }
    }
}

struct ImageViewWrapper<Content: View, Failure: View, Placeholder: View>: View {
    @ObservedObject var imageManager: ImageManager
    
    let url: URL?
    let imageView: ImageViewRepresentable
    let content: (_ imgView: ImageViewRepresentable) -> Content
    
    private let failure: (_ error: Error) -> Failure
    private let placeholder: () -> Placeholder
    
    init(url: URL?,
         @ViewBuilder placeholder: @escaping () -> Placeholder,
         @ViewBuilder failure: @escaping (_ error: Error) -> Failure,
         @ViewBuilder content: @escaping (_ imgView: ImageViewRepresentable) -> Content)
    {
        self.url = url
        self.placeholder = placeholder
        self.failure = failure
        self.content = content
        
        let manager = ImageManager()
        self.imageManager = manager
        self.imageView = ImageViewRepresentable(url: url, imageManager: manager)
        self.imageView.loadImage()
    }
    
    var body: some View {
        ZStack {
            switch imageManager.state {
            case .initial:
                placeholder()
            case .completed(image: _):
                content(imageView)
            case .error(let error):
                failure(error)
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
}

extension ImageViewWrapper where Placeholder == EmptyView, Failure == EmptyView {
    init(url: URL?,
         @ViewBuilder content: @escaping (_ imgView: ImageViewRepresentable) -> Content)
    {
        self.init(url: url,
                  placeholder: { EmptyView() },
                  failure: { _ in EmptyView() },
                  content: content)
    }
}

extension ImageViewWrapper where Failure == EmptyView {
    init(url: URL?,
         @ViewBuilder placeholder: @escaping () -> Placeholder,
         @ViewBuilder content: @escaping (_ imgView: ImageViewRepresentable) -> Content)
    {
        self.init(url: url,
                  placeholder: placeholder,
                  failure: { _ in EmptyView() },
                  content: content)
    }
}

extension ImageViewWrapper where Placeholder == EmptyView {
    init(url: URL?,
         @ViewBuilder failure: @escaping (_ error: Error) -> Failure,
         @ViewBuilder content: @escaping (_ imgView: ImageViewRepresentable) -> Content)
    {
        self.init(url: url,
                  placeholder: { EmptyView() },
                  failure: failure,
                  content: content)
    }
}

#if DEBUG
    struct ImageViewWrapper_Previews: PreviewProvider {
        static var previews: some View {
            let url = URL(string: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/2019-mustang-shelby-gt350-101-1528733363.jpg?crop=0.817xw:1.00xh;0.149xw,0&resize=640:*")
            let gifURL = URL(string: "http://assets.sbnation.com/assets/2512203/dogflops.gif")
            VStack {
                ImageViewWrapper(url: url, content: { $0.frame(width: 100, height: 100) })
            
                ImageViewWrapper(url: gifURL, content: { $0.frame(width: 300, height: 300) })
            
                ImageViewWrapper(url: nil,
                                 failure: { _ in Text("load image failed") },
                                 content: { $0.frame(width: 300, height: 300) })
            }
        }
    }
#endif
