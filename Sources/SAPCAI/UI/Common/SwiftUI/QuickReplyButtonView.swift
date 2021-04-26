import SwiftUI

struct QuickReplyButtonView: View {
    var button: PostbackData

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ButtonView(button: button, type: .quickReply)
            .buttonStyle(self.themeManager.value(for: .quickReplyButtonStyle,
                                                 type: BaseQuickReplyButtonStyle.self,
                                                 defaultValue: BaseQuickReplyButtonStyle()))
    }
}

struct QuickReplyButtonView_Previews: PreviewProvider {
    static var previews: some View {
        QuickReplyButtonView(button: UIModelDataAction("b1", "b1", .text)).environmentObject(ThemeManager.shared)
    }
}
