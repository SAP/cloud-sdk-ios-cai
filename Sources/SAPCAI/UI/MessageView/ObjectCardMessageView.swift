import SwiftUI

struct ObjectCardMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let model: ObjectMessageData

    var imageUrl: URL? {
        if let sUrl = model.imageUrl, let url = URL(string: sUrl) {
            return url
        }
        return nil
    }

    private var hasButtons: Bool {
        self.model.objectButtons != nil && !self.model.objectButtons!.isEmpty
    }

    private var hasSections: Bool {
        self.model.objectSections != nil && !self.model.objectSections!.isEmpty
    }

    private var buttonsLen: Int {
        min(self.model.objectButtons != nil ? self.model.objectButtons!.count : 0, 3)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                if imageUrl != nil {
                    ImageView(imageUrl: imageUrl!)
                        .frame(width: 50, height: 50)
                }
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 6) {
                        if let headline = model.headline {
                            Text(headline)
                                .font(Font.fiori(forTextStyle: .headline).weight(.bold))
                                .foregroundColor(themeManager.color(for: .primary1))
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if let subheadline = model.subheadline {
                            Text(subheadline)
                                .font(Font.fiori(forTextStyle: .body))
                                .foregroundColor(themeManager.color(for: .primary2))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if let footnote = model.footnote {
                            Text(footnote)
                                .font(Font.fiori(forTextStyle: .subheadline))
                                .foregroundColor(themeManager.color(for: .primary2))
                                .lineLimit(5)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        if let status = model.status {
                            ItemStatus(status: status)
                        }
                        if let substatus = model.substatus {
                            Text(substatus)
                                .font(Font.fiori(forTextStyle: .subheadline))
                                .foregroundColor(themeManager.color(for: .primary2))
                        }
                    }
                }
            }
            .padding(16)
            // sections
            if self.hasSections && model.objectSections![0].sectionAttributes != nil {
                Divider().background(self.themeManager.color(for: .lineColor))
                CardSectionsView(section: model.objectSections![0])
            }
            // buttons
            if self.hasButtons {
                Divider().background(self.themeManager.color(for: .lineColor))
                ForEach(0 ..< buttonsLen) { i in
                    VStack(alignment: .center, spacing: 0) {
                        ButtonView(button: self.model.objectButtons![i], type: .button)

                        if i < self.buttonsLen - 1 {
                            Divider().background(self.themeManager.color(for: .lineColor))
                        }
                    }
                    .frame(minHeight: 44)
                }
            }
        }
        .background(roundedBorder(for: self.themeManager.theme))
    }
}

#if DEBUG
    struct ObjectCardMessageView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ObjectCardMessageView(model: UIModelDataContent(text: "text1", list: nil, form: nil, picture: nil, video: nil,
                                                                header: UIModelDataHeader(options: .all),
                                                                buttons: [
                                                                    UIModelDataAction("b1", "b1", .text),
                                                                    UIModelDataAction("b2", "b2", .text)
                                                                ]))

                ObjectCardMessageView(model: UIModelDataContent(text: "text1", list: nil, form: nil, picture: nil, video: nil,
                                                                header: UIModelDataHeader(options: [.description, .status1]),
                                                                buttons: [
                                                                    UIModelDataAction("b1", "b1", .text),
                                                                    UIModelDataAction("b2", "b2", .text)
                                                                ]))
            }
            .environmentObject(ThemeManager.shared)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
