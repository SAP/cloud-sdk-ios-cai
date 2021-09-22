import SwiftUI

struct CarouselButtonsView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var buttonsData: [PostbackData]?
    var actionBlock: (() -> Void)?
    
    var body: some View {
        HStack {
            if buttonsData != nil {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(buttonsData!, id: \.id) { button in
                        VStack(alignment: .center, spacing: 0) {
                            ButtonView(button: button, type: .button, actionBlock: actionBlock)
                            
                            if button.id != self.buttonsData!.last!.id {
                                Divider().background(self.themeManager.color(for: .lineColor))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CarouselButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselButtonsView(buttonsData: nil)
    }
}
