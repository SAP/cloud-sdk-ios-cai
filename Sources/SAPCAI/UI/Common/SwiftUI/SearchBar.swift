import SwiftUI

/// SearchBar
/// SwiftUI wrapper for rendering a TextField,  magnifer icon and clear button while editing
public struct SearchBar<S>: View where S: StringProtocol {
    @Binding var text: String
    
    @State private var isActiveBar: Bool = false
    
    var placeholder: S
    
    var onCommit: () -> Void
    
    /// Constructor
    /// - Parameters:
    ///   - placeholder: Placeholder. Should conform to StringProtocol
    ///   - text: Binding<String>
    ///   - onCommit: Handler called when user presses return
    public init(_ placeholder: S, text: Binding<String>, _ onCommit: @escaping () -> Void) {
        self._text = text
        self.placeholder = placeholder
        self.onCommit = onCommit
    }
    
    /// :nodoc:
    public var body: some View {
        HStack(alignment: .center, spacing: 6) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(placeholder, text: self.$text, onEditingChanged: { isActive in
                    self.isActiveBar = isActive
                }, onCommit: {
                    self.onCommit()
                })
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }

            Button(action: {
                UIApplication.shared.mainWindow?.endEditing(true)
                self._text.wrappedValue = ""
            }, label: {
                Text(Bundle.cai.localizedString(forKey: "Clear", value: "Clear", table: nil))
            })
                .offset(CGSize(width: isActiveBar ? 0 : 150, height: 0))
        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .animation(.linear)
    }
}

#if DEBUG
    struct SearchBar_Previews: PreviewProvider {
        static var previews: some View {
            SearchBar("search", text: .constant("movies")) {
                print("")
            }
        }
    }
#endif
