import Combine
import SwiftUI

/// SwiftUI main view. Use this when you want a full screen out-of-the box view that contains:
/// - `BannerView` hidden by default that slides down to display any errors.
/// - `ChatView`
/// - `InputBarView`
/// This view will apply the accent color defined in your theme.
///
/// Safe Area is ignored at the bottom so the InputBarView can extend and apply the backrgound Blur Effect all the way.
///
/// To function properly, this view requires 2 @EnvironmentObject objects to be set:
/// - viewModel: MessagingViewModel
/// - themeManager: ThemeManager. Recommended to use `ThemeManager.shared`
///
/// Usage example:
/// ```
/// AssistantView()
///     .navigationBarTitle(Text("Chat"), displayMode: .inline) // if you are in navigation controller
///     .environmentObject( MessagingViewModel(publisher:
///                           CAIConversation(config: CAIServiceConfig(SAPURLSession(), <#backendURL#>),
///                                           channel: "<#channelId#>",
///                                           token: "<#channelToken#>") )
///     .environmentObject(themeManager)
/// ```
public struct AssistantView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var inputBarViewHeight: CGFloat = 0

    @State private var chartViewBottomInsert: CGFloat = 0

    private var data: TypingIndicatorData = {
        let d = TypingIndicatorData()
        d.dotColor = Color.secondary
        return d
    }()

    /// :nodoc:
    public init() {}
    
    /// :nodoc:
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if self.viewModel.latestError != nil {
                    BannerView(self.viewModel.latestError!.localizedDescription, type: .error, closeIndicator: true)
                        .onTapGesture {
                            self.viewModel.latestError = nil
                        }
                        .zIndex(1)
                }
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        ChatView(data: self.data, bottomInset: self.$chartViewBottomInsert)
                        
                        InputBarView()
                            .padding(.bottom)
                            .background(BlurView().edgesIgnoringSafeArea(.bottom)) // themeManager.color(for: .inputBarBGColor))
                            .overlay(Divider(), alignment: .top)
                    }
                    .accentColor(self.themeManager.color(for: .accentColor))
                    .frame(height: self.viewModel.getHeight(for: geometry), alignment: .top)
                    .onPreferenceChange(InputBarViewHeightPrefKey.self) { value in
                        self.inputBarViewHeight = value
                        self.chartViewBottomInsert = self.inputBarViewHeight
                    }
                    .onReceive(self.viewModel.$contentHeight) { output in
                        let extraSpacing = CGFloat(8) // without some extra spacing (when keyboard is opened) then the keyboard does not push ChatView up enough
                        let newBottomInsert = (output > 0) ? self.inputBarViewHeight + extraSpacing : self.inputBarViewHeight
                        self.chartViewBottomInsert = newBottomInsert
                    }
                    
                    Spacer().frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity)
                }
                .zIndex(0)
            }
        }
        .background(self.themeManager.color(for: .backgroundBase))
        .onAppear {
            self.viewModel.load()
        }
    }
}

#if DEBUG
    struct AssistantView_Previews: PreviewProvider {
        static func getFioriThemeManager() -> ThemeManager {
            let t = ThemeManager()
            t.setCurrentTheme(.fiori(FioriColorPalette()))
            return t
        }

        static func getCasualThemeManager() -> ThemeManager {
            let t = ThemeManager()
            t.setCurrentTheme(.casual(CasualColorPalette()))
            return t
        }

        static var previews: some View {
            Group {
                HStack {
                    AssistantView().environmentObject(testData).environmentObject(getFioriThemeManager())
                    AssistantView().environmentObject(testData).environmentObject(getCasualThemeManager())
                }
                .frame(width: 800, height: 800)

            }.previewLayout(PreviewLayout.sizeThatFits).previewDisplayName("Fiori vs. Casual Design")

//        AssistantView().environmentObject(testData).environmentObject(getFioriThemeManager())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
//            .previewDisplayName("Fiori Design")
        }
    }
#endif
