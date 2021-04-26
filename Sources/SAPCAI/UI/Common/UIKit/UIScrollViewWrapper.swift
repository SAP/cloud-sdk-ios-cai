import SAPCommon
import SwiftUI

/// UIScrollView's wrapper for SwiftUI
///
/// Only vertical scrolling is supported
struct UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {
    // MARK: - Type

    typealias UIViewControllerType = UIScrollViewController<Content>
    
    // MARK: - Properties
    
    private var offset: Binding<CGPoint>
    private let animationDuration: TimeInterval
    private var content: () -> Content
    private let showsScrollIndicator: Bool
    private let axis: Axis
    private let automaticallyScrollsToBottom: Bool
    private let geometry: GeometryProxy

    // MARK: - Init
    
    /// Constructor
    /// - Parameters:
    ///   - offset: Binding CGPoint to control scrollview contentOffset. IGNORED for now
    ///   - geometry: GeometryProxy. Required to know what is the container size the scrollview is rendered in.
    ///   - automaticallyScrollsToBottom: Bool. If true, scroll view will automatically scroll to the bottom when new items are inserted. Default is true.
    ///   - showsScrollIndicator: Bool. Default is true.
    ///   - content: Closure for content of the scroll view
    init(_ offset: Binding<CGPoint>,
         geometry: GeometryProxy,
         automaticallyScrollsToBottom: Bool = true,
         showsScrollIndicator: Bool = true,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.offset = offset
        self.animationDuration = 0.5
        self.content = content
        self.showsScrollIndicator = showsScrollIndicator
        self.axis = .vertical
        self.automaticallyScrollsToBottom = automaticallyScrollsToBottom
        self.geometry = geometry
    }
    
    // MARK: - Updates
    
    /// :nodoc:
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        let scrollViewController = UIScrollViewController(rootView: self.content(),
                                                          offset: self.offset,
                                                          axis: self.axis,
                                                          automaticallyScrollsToBottom: self.automaticallyScrollsToBottom)
        scrollViewController.scrollView.showsVerticalScrollIndicator = self.showsScrollIndicator
        scrollViewController.scrollView.showsHorizontalScrollIndicator = false

        return scrollViewController
    }
    
    /// :nodoc:
    func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
        viewController.view.frame = CGRect(origin: .zero, size: self.geometry.size)

        // call layoutIfNeeded otherwise frame might not be updated on device orientation change
        viewController.view.layoutIfNeeded()

        viewController.updateContent(self.content)
        
//        let duration: TimeInterval = self.duration(viewController)
//        guard duration != .zero else {
//            viewController.scrollView.contentOffset = self.offset.wrappedValue
//            return
//        }
//
//        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: {
//            viewController.scrollView.contentOffset = self.offset.wrappedValue
//        }, completion: nil)
    }
    
    // Calculate animation speed
    private func duration(_ viewController: UIViewControllerType) -> TimeInterval {
        var diff: CGFloat = 0
        
        switch self.axis {
        case .horizontal:
            diff = abs(viewController.scrollView.contentOffset.x - self.offset.wrappedValue.x)
        default:
            diff = abs(viewController.scrollView.contentOffset.y - self.offset.wrappedValue.y)
        }
        
        if diff == 0 {
            return .zero
        }
        
        let percentageMoved = diff / UIScreen.main.bounds.height
        
        return self.animationDuration * min(max(TimeInterval(percentageMoved), 0.25), 1)
    }
}

/// :nodoc:
final class UIScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate, ObservableObject {
    // MARK: - Properties

    private var offset: Binding<CGPoint>
    private let hostingController: UIHostingController<Content>
    private let axis: Axis
    private let automaticallyScrollsToBottom: Bool
    
    private var currentContentSize: CGSize = .zero
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return scrollView
    }()

    private var logger = Logger.shared(named: "CAI.UIScrollViewController")

    // MARK: - Init

    init(rootView: Content, offset: Binding<CGPoint>, axis: Axis, automaticallyScrollsToBottom: Bool) {
        self.offset = offset
        self.hostingController = UIHostingController<Content>(rootView: rootView)
        self.hostingController.view.backgroundColor = .clear
        self.axis = axis
        self.automaticallyScrollsToBottom = automaticallyScrollsToBottom
        
        super.init(nibName: nil, bundle: nil)
        
        self.scrollView.addSubview(self.hostingController.view)
    }
    
    // MARK: - Update

    func updateContent(_ content: () -> Content) {
        self.hostingController.rootView = content()
        
        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize
        
        switch self.axis {
        case .vertical:
            contentSize.width = self.scrollView.frame.width
        case .horizontal:
            contentSize.height = self.scrollView.frame.height
        }
        
        self.hostingController.view.frame.size = contentSize
        self.scrollView.contentSize = contentSize
        
        self.logger.debug("contentSize: \(contentSize)")
        if self.automaticallyScrollsToBottom, contentSize != self.currentContentSize {
            // scroll to bottom
            self.scrollView.scrollToBottom(animated: true)
            self.currentContentSize = contentSize
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        self.createConstraints()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        DispatchQueue.main.async {
//            self.offset.wrappedValue = scrollView.contentOffset
//        }
    }
    
    // MARK: - Constraints

    fileprivate func createConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
