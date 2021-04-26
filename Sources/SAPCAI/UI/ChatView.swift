import SwiftUI

/// Renders a ScrollView with the list of messages provided by the `MessagingViewModel`
public struct ChatView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    var data: TypingIndicatorData
    
    @Binding var bottomInset: CGFloat
    
    @State private var contentOffset: CGPoint = .zero
    
    public init(data: TypingIndicatorData, bottomInset: Binding<CGFloat> = .constant(0)) {
        self.data = data
        self._bottomInset = bottomInset
    }
        
    /// :nodoc:
    public var body: some View {
        GeometryReader { geometry in
            // Not using a List because:
            // - we don't want a separator
            // - we can still wrap a NavigationButton around
            UIScrollViewWrapper(self.$contentOffset, geometry: geometry) {
                VStack(spacing: self.vSizeClass == .compact ? 2 : 4) { // minimum spacing between messages
                    ForEach(self.viewModel.model, id: \.id) { model in
                        // each message goes here
                        VStack(spacing: 0) {
                            MessageView(model: model, geometry: geometry)
                                .padding([.trailing, .leading],
                                         self.themeManager.value(for: .containerLTPadding,
                                                                 type: CGFloat.self,
                                                                 defaultValue: 0))
                                .frame(width: geometry.size.width,
                                       alignment: model.sender.isBot ? .leading : .trailing)
                                .environmentObject(self.viewModel)
                                .environmentObject(self.themeManager)
                                .onPreferenceChange(ImageSizeInfoPrefKey.self) { value in
                                    // updating the offset so the layout happens. value itself is not used
                                    self.contentOffset = CGPoint(x: self.contentOffset.x, y: self.contentOffset.y + value.height)
                                }
                            if model.isLastMessage {
                                Spacer().frame(height: self.vSizeClass == .compact ? 6 : 12)
                            }
                        }
                    }
                    if self.viewModel.isRequestPending {
                        Run {
                            self.data.startAnimation()
                        }
                        HStack {
                            TypingIndicatorView(data: self.data)
                            Spacer()
                        }
                        .padding([.leading, .trailing], self.themeManager.value(for: .containerLTPadding, type: CGFloat.self, defaultValue: 0))
                        .padding([.top, .bottom], 4)
                    } else {
                        Run {
                            self.data.stopAnimation()
                        }
                    }
                }
                .padding([.top], 12)
                .padding([.bottom], self.bottomInset)
                .padding(.bottom)
                .frame(minWidth: 0, idealWidth: geometry.size.width, maxWidth: .infinity)
                // keep this or it won't work with empty model https://github.com/mecid/swiftui-scrollview-bug
            }
            .sheet(isPresented: self.$viewModel.urlOpenerData.isLinkModalPresented, onDismiss: {
                // reset
                self.viewModel.urlOpenerData = URLOpenerData()
            }, content: {
                SafariUIView(url: URL(string: self.viewModel.urlOpenerData.url)!)
            })
        }
    }
}

struct Run: View {
    let block: () -> Void

    var body: some View {
        block()
        return AnyView(EmptyView())
    }
}

#if DEBUG
    struct ChatView_Previews: PreviewProvider {
        static var previews: some View {
            ChatView(data: TypingIndicatorData()).environmentObject(testData).environmentObject(ThemeManager.shared)
        }
    }
#endif
