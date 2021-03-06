import SwiftUI

struct QuickReplyButtonView: View {
    var button: PostbackData
    var postbackType: PostbackType = .quickReply

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ButtonView(button: button, type: postbackType, buttonViewType: .quickReply)
            .buttonStyle(self.themeManager.value(for: .quickReplyButtonStyle,
                                                 type: QuickReplyButtonStyleContainer.self,
                                                 defaultValue: QuickReplyButtonStyleContainer(BaseQuickReplyButtonStyle())))
    }
}

struct QuickReplyButtonView_Previews: PreviewProvider {
    static var previews: some View {
        QuickReplyButtonView(button: UIModelDataAction("b1", "b1", .text)).environmentObject(ThemeManager.shared)
    }
}
