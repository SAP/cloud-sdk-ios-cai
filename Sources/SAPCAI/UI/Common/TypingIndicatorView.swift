import Combine
import SwiftUI

/// Generic mechanism to toggle between 2 values
struct Toggable<T: Equatable>: Equatable {
    static func == (lhs: Toggable<T>, rhs: Toggable<T>) -> Bool {
        lhs.value == rhs.value
    }
    
    private var tuple: (T, T)
    
    var value: T {
        self.tuple.0
    }
    
    init(_ value: T) {
        self.tuple = (value, value)
    }
    
    init(_ value1: T, _ value2: T) {
        self.tuple = (value1, value2)
    }
    
    mutating func toggle() {
        let tmp = self.tuple.0
        self.tuple.0 = self.tuple.1
        self.tuple.1 = tmp
    }
}

/// The data model for the typing indicator SwiftUI view `TypingIndicatorView`. Implements ObservableObject protocol.
public final class TypingIndicatorData: ObservableObject, Identifiable {
    /// A single circle.
    public struct Dot: Identifiable {
        public var id: Int
        
        var startColor: Color
        
        var endColor: Color
        
        public init(_ id: Int, _ startColor: Color = Color.primary, _ endColor: Color = Color.secondary) {
            self.id = id
            self.startColor = startColor
            self.endColor = endColor
        }

        /// Update start and color with one defined color.
        /// Sets color to startColor and endColor gets a 80% transparency applied
        /// - Parameter color: Color
        mutating func update(color: Color) {
            self.startColor = color
            self.endColor = color.opacity(0.8)
        }
    }
    
    // MARK: - Public properties
    
    /// Update start and color with one defined color.
    /// Sets color to startColor and endColor gets a 80% transparency applied
    public var dotColor: Color = .secondary {
        didSet {
            self.dots.modifyForEach { _, dot in
                dot.update(color: dotColor)
            }
        }
    }
    
    public var startColor = Color.primary {
        didSet {
            self.dots.modifyForEach { _, dot in
                dot.startColor = startColor
            }
        }
    }

    public var endColor = Color.secondary {
        didSet {
            self.dots.modifyForEach { _, dot in
                dot.endColor = endColor
            }
        }
    }

    /// Time for the dot to animate (one direction). Default is 0.5s
    public var animationDuration: TimeInterval = 0.5 {
        didSet {
            self.animation = Animation.easeInOut(duration: self.animationDuration)
        }
    }
    
    /// Time while the dot animation is idle before starting again. Default is 0.5s
    public var idleDuration: TimeInterval = 0.5

    /// Sets dot size. Default is 12x12
    @Published public var dotSize = CGSize(width: 8, height: 8)

    /// Sets grow scale ratio of each dot during animation. Default is 1.25.
    @Published public var scaleRatio: CGFloat = 1.5
    
    // MARK: - Private
        
    /// Animation used for each dot
    var animation: Animation
    
    /// The collection of dots, tracked by their id.
    var dots: [Dot] = [Dot(0), Dot(1), Dot(2)]
    
    /// When true, typing indicator is animated, each dot color is periodically updated.
    /// Update the value in `.onAppear` and `.onDisappear`
    @Published var anims: [Bool] = [false, false, false]

    private var timers = [Timer]()
    
    // MARK: - Public APIs
    
    public init() {
        self.animation = Animation.easeInOut(duration: self.animationDuration)
//            .repeatCount(2, autoreverses: true)
//            .repeatForever(autoreverses: true)
    }
    
    public init(dots: [Dot]) {
        self.dots = dots
        self.anims = [Bool](repeating: false, count: dots.count)
        self.animation = Animation.easeInOut(duration: self.animationDuration)
    }
    
    deinit {
        timers.forEach { $0.invalidate() }
        timers.removeAll()
    }
    
    /// Starts animation.
    public func startAnimation() {
        guard self.timers.isEmpty else { return }
        
        for i in self.dots.indices {
            let delay = Double(i) / Double(self.dots.count - 1) * self.animationDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.startAnimation(i)
            }
        }
    }
    
    /// Stop animation.
    public func stopAnimation() {
        self.timers.forEach {
            $0.invalidate()
        }
        self.timers.removeAll()
    }
    
    // MARK: - Private functions
    
    private func startAnimation(_ i: Int) {
        self.animateDotOnce(at: i)
        let t = Timer.scheduledTimer(withTimeInterval: self.animationDuration * 2 + self.idleDuration, repeats: true) { _ in
            self.animateDotOnce(at: i)
        }
        self.timers.append(t)
    }
    
    private func animateDotOnce(at index: Int) {
        self.anims[index] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
            self.anims[index] = false
        }
    }
}

// MARK: - SwiftUI View

/// A view drawing an animated 3 dots. Use `TypingIndicatorData` to customize it.
/// The view comes with a default frame already set.
public struct TypingIndicatorView: View {
    @ObservedObject private var data: TypingIndicatorData
    
    public init(data: TypingIndicatorData) {
        self.data = data
    }
    
    public var body: some View {
        HStack(spacing: self.data.dotSize.width / 2) {
            ForEach(0 ..< data.dots.count) { i in
                Circle()
                    .fill(self.data.anims[i] ? self.data.dots[i].endColor : self.data.dots[i].startColor)
                    .scaleEffect(self.data.anims[i] ? self.data.scaleRatio : 1)
                    .animation(self.data.animation)
                    .frame(width: self.data.dotSize.width, height: self.data.dotSize.height)
            }
        }
        .padding([.top, .bottom], (self.data.dotSize.height / 2 * self.data.scaleRatio) - (self.data.dotSize.height / 2))
        .layoutPriority(1)
        .onAppear {
            self.data.startAnimation()
        }
        .onDisappear {
            self.data.stopAnimation()
        }
    }
}

#if DEBUG
    struct TypingIndicatorView_Previews: PreviewProvider {
        static var previews: some View {
            TypingIndicatorView(data: TypingIndicatorData())
        }
    }
#endif
