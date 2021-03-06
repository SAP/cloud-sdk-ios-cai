import SwiftUI

struct ButtonsMessageView: View {
    let model: MessageData
    
    let geometry: GeometryProxy
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    @Environment(\.horizontalSizeClass) private var hSizeClass

    var buttons: ButtonsMessageData? {
        if case .buttons(let data) = self.model.type {
            return data
        }
        return nil
    }

    @State private var showMoreButtons: Bool = false
    
    var body: some View {
        let showMoreLen = min(buttons!.buttonsData != nil ? buttons!.buttonsData!.count : 0, 15)
        let showLessLen = min(buttons!.buttonsData != nil ? buttons!.buttonsData!.count : 0, 5)

        return VStack(alignment: .leading, spacing: 5) {
            BotTextView(value: NSAttributedString(string: buttons!.buttonText!), isMarkdown: false, geometry: geometry)
                .textWidth(geometry, isRegular: hSizeClass == .regular, isBot: model.sender.isBot)
            
            if buttons!.buttonsData != nil {
                VStack(alignment: .leading, spacing: 0) {
                    if self.showMoreButtons {
                        ForEach(0 ..< showMoreLen, id: \.self) { i in
                        
                            VStack(alignment: .leading, spacing: 0) {
                                ButtonView(button: self.buttons!.buttonsData![i], type: .button, buttonViewType: .menuSelectionButton)
                                if i < showMoreLen - 1 {
                                    Divider().background(self.themeManager.color(for: .lineColor))
                                }
                            }
                        }
                        
                    } else {
                        ForEach(0 ..< showLessLen, id: \.self) { i in
                        
                            VStack(alignment: .leading, spacing: 0) {
                                ButtonView(button: self.buttons!.buttonsData![i], type: .button, buttonViewType: .menuSelectionButton)
                                
                                if i < showLessLen - 1 {
                                    Divider().background(self.themeManager.color(for: .lineColor))
                                }
                                if i == 4, self.buttons!.buttonsData!.count > showLessLen {
                                    Divider().background(self.themeManager.color(for: .lineColor))
                                    Button(action: {
                                        self.viewModel.contentHeight += 0
                                        self.showMoreButtons = true
                                    }, label: {
                                        Spacer()
                                        Text(Bundle.cai.localizedString(forKey: "View more", value: "View more", table: nil))
                                            .font(.body)
                                            .lineLimit(1)
                                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                        Spacer()
                                    })
                                }
                            }
                        }
                    }
                }.background(roundedBorder(for: self.themeManager.theme))
            }
        }
    }
}

#if DEBUG
    struct ButtonsMessageView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                GeometryReader { geometry in
                    ButtonsMessageView(
                        model: self.createButtons(amount: 5, for: "Hide 'View More' button as there are no more buttons"),
                        geometry: geometry
                    )
                    .environmentObject(MessagingViewModel(publisher: MockPublisher()))
                    .environmentObject(ThemeManager.shared)
                }
                .environment(\.sizeCategory, .extraSmall)
                .previewLayout(.fixed(width: 400, height: 500))

                GeometryReader { geometry in
                    ButtonsMessageView(
                        model: self.createButtons(amount: 6, for: "Show 'View More' button visible as there are more buttons"),
                        geometry: geometry
                    )
                    .environmentObject(MessagingViewModel(publisher: MockPublisher()))
                    .environmentObject(ThemeManager.shared)
                }
                .environment(\.sizeCategory, .extraSmall)
                .previewLayout(.fixed(width: 400, height: 500))

                GeometryReader { geometry in
                    ScrollView {
                        ButtonsMessageView(
                            model: self.createButtons(amount: 20, for: "Show 'View More' button visible as there are more buttons but show only up to 15 buttons"),
                            geometry: geometry
                        )
                        .environmentObject(MessagingViewModel(publisher: MockPublisher()))
                        .environmentObject(ThemeManager.shared)
                    }
                }
                .environment(\.sizeCategory, .extraSmall)
                .previewLayout(.fixed(width: 400, height: 500))
                .previewLayout(.sizeThatFits)
            }
        }

        static func createButtons(amount: Int, for testDesc: String) -> CAIResponseMessageData {
            var buttons: [UIModelDataAction] = []
            for n in 0 ..< amount {
                buttons.append(UIModelDataAction("button \(n + 1)", "b\(n + 1)", .text))
            }
            return CAIResponseMessageData(text: testDesc, buttons, buttonType: .buttons)
        }
    }
#endif
