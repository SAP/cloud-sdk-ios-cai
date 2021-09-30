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
    }
}

/// :nodoc:
final class UIScrollViewController<Content: View>: UIViewController {
    // MARK: - Properties

    private var offset: Binding<CGPoint>
    private let hostingController: UIHostingController<Content>
    private let axis: Axis
    private let automaticallyScrollsToBottom: Bool
    
    private var currentContentSize: CGSize = .zero
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .zero
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
            self.scrollView.scrollToBottom(animated: true, adjust: self.hostingController.view.safeAreaInsets.top)
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
        self.scrollView.pin(to: self.view)
        addChild(self.hostingController)
        self.scrollView.addSubview(self.hostingController.view)
        if #available(iOS 15, *) {
        } else {
            self.hostingController.view.pin(to: self.scrollView)
        }
        self.hostingController.didMove(toParent: self)
    }
    
    #if swift(>=5.5)
        @available(iOS 15.0, *)
        override func contentScrollView(for edge: NSDirectionalRectEdge) -> UIScrollView? {
            if self.hostingController.view.frame.size != self.hostingController.view.intrinsicContentSize {
                self.hostingController.view.frame.size = self.hostingController.view.intrinsicContentSize
                self.scrollView.contentSize = self.hostingController.view.intrinsicContentSize
            }
            return super.contentScrollView(for: edge)
        }
    #endif
}
