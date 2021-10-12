import Foundation
import SwiftUI

struct ListItemView: View {
    var model: ObjectMessageData

    var body: some View {
        NavigationLink(destination: CardPageView(card: model)
            .environmentObject(ThemeManager.shared)) {
            ObjectMessageView(model: model)
        }
    }
}

#if DEBUG
    struct ListItemView_Previews: PreviewProvider {
        static var previews: some View {
            ListItemView(model: PreviewData.objectMessage.first!)
                .previewLayout(.sizeThatFits)
                .environmentObject(ThemeManager.shared)
        }
    }
#endif
