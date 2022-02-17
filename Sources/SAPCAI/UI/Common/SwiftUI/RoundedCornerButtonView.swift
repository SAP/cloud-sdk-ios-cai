import SwiftUI

struct RoundedCornerButtonView: View {
    var button: PostbackData
    var postbackType: PostbackType = .button

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ButtonView(button: button, type: postbackType, buttonViewType: .roundedCornerButton)
            .buttonStyle(self.themeManager.value(for: .roundedCornerButtonStyle,
                                                 type: RoundedCornerButtonStyleContainer.self,
                                                 defaultValue: RoundedCornerButtonStyleContainer(BaseRoundedCornerButtonStyle())))
    }
}

struct RoundedCornerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedCornerButtonView(button: UIModelDataAction("b1", "b1", .text)).environmentObject(ThemeManager.shared)
    }
}
