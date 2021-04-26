import SwiftUI

/// Renders a message to the user about an unsupported type.
struct UnknownMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var model: MessageData

    var body: some View {
        HStack(alignment: .bottom) {
            Text("Unsupported type")
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(roundedBorder(for: themeManager.theme))
                .layoutPriority(1)
        }
    }
}

#if DEBUG
    struct UnknownMessageView_Previews: PreviewProvider {
        static var previews: some View {
            UnknownMessageView(model: testData.model[0]).environmentObject(ThemeManager.shared)
        }
    }
#endif
