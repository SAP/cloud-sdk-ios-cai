import SwiftUI

/// InputBar view.
/// Wraps a `TextView` and Send button. Send will call `MessagingViewModel.postMessage(text: String)`
/// Height of the TextView grows as user types longer text.
public struct InputBarView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var value: String = ""

    @State private var textViewHeight: CGFloat = 38
        
    /// :nodoc:
    public init() {}
    
    private func postMessage() {
        // dismiss keyboard
        UIApplication.shared.mainWindow?.endEditing(true)

        guard !self.value.isEmpty else {
            return
        }

        self.viewModel.postMessage(text: self.value)
        self.value = ""
    }
    
    var menu: MenuData? {
        if let data = viewModel.menu?.menuData {
            return data
        }
        return nil
    }

    /// :nodoc:
    public var body: some View {
        HStack(spacing: 16) {
            if self.menu != nil {
                MenuButtonView(menuActions: self.menu!.menuActions)
            }
            
            ZStack(alignment: .bottomTrailing) {
                TextView(Bundle.cai.localizedString(forKey: "Write a message", value: "Ask me please", table: nil), text: self.$value, textViewHeight: self.$textViewHeight) {
                    self.postMessage()
                }
                .frame(height: textViewHeight)
                
                Button(action: {
                    self.postMessage()
                    
                }, label: {
                    Image(systemName: self.themeManager.value(for: .sendButton, type: String.self, defaultValue: "arrow.up.square.fill"))
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding([.bottom, .trailing], 5)
                })
                    .disabled(self.value.isEmpty)
            }
            .preference(key: InputBarViewHeightPrefKey.self, value: textViewHeight + 16)
        }
        .padding([.leading, .trailing], themeManager.value(for: .containerLTPadding, type: CGFloat.self, defaultValue: 10))
        .padding([.top, .bottom], 8)
    }
}

struct InputBarViewHeightPrefKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 54
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#if DEBUG
    struct InputBarView_Previews: PreviewProvider {
        static var previews: some View {
            InputBarView().environmentObject(testData).environmentObject(ThemeManager.shared)
        }
    }
#endif
