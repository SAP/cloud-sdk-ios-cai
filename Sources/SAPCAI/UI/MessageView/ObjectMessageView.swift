import SwiftUI

struct ObjectMessageView: View {
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
    
    private var hasStatus: Bool {
        self.model.status != nil && self.model.status!.value != nil
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if imageUrl != nil {
                ImageView(imageUrl: imageUrl!)
                    .frame(width: 50, height: 50)
            }
            HStack(alignment: self.hasButtons && !self.hasStatus ? .center : .firstTextBaseline) {
                VStack(alignment: .leading) {
                    if model.headline != nil {
                        Text(model.headline!)
                            .font(.headline)
                            .foregroundColor(themeManager.color(for: .primary1))
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if model.headline != nil {
                        Text(model.subheadline!)
                            .font(.body)
                            .foregroundColor(themeManager.color(for: .primary2))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if model.footnote != nil {
                        Text(model.footnote!)
                            .font(.subheadline)
                            .foregroundColor(themeManager.color(for: .primary2))
                            .lineLimit(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                Spacer()
                if self.hasButtons, !self.hasStatus {
                    if model.objectButtons!.count == 1 {
                        QuickReplyButtonView(button: self.model.objectButtons![0], postbackType: .button)
                            .frame(minWidth: 99, maxWidth: 100, alignment: .trailing)
                    } else {
                        MultiButtonsView(buttons: self.model.objectButtons!)
                    }
                } else {
                    VStack(alignment: .trailing, spacing: 6) {
                        if self.hasStatus {
                            if model.status!.valState == .success {
                                Text(model.status!.value!)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.color(for: .successColor))
                            } else if model.status!.valState == .error {
                                Text(model.status!.value!)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.color(for: .errorColor))
                            } else if model.status!.valState == .warn {
                                Text(model.status!.value!)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.color(for: .warnColor))
                            } else if model.status!.valState == .info {
                                Text(model.status!.value!)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.color(for: .infoColor))
                            } else {
                                Text(model.status!.value!)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.color(for: .primary2))
                            }
                        }
                        if self.hasButtons {
                            if model.objectButtons!.count == 1 {
                                QuickReplyButtonView(button: self.model.objectButtons![0], postbackType: .button)
                                    .frame(minWidth: 99, maxWidth: 100, alignment: .trailing)
                            } else {
                                MultiButtonsView(buttons: self.model.objectButtons!)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
    }
}

#if DEBUG
    struct ObjectMessageView_Previews: PreviewProvider {
        static var previews: some View {
            ObjectMessageView(model: UIModelDataContent(text: "text1", list: nil, form: nil, picture: nil, video: nil,
                                                        header: UIModelDataHeader(title: UIModelDataValue(value: "title", dataType: UIModelData.ValueType.text.rawValue, rawValue: nil,
                                                                                                          label: nil,
                                                                                                          valueState: nil),
                                                                                  subtitle: UIModelDataValue(value: "subtitle", dataType: UIModelData.ValueType.text.rawValue,
                                                                                                             rawValue: nil,
                                                                                                             label: nil,
                                                                                                             valueState: nil),
                                                                                  description: UIModelDataValue(value: "desc", dataType: UIModelData.ValueType.text.rawValue,
                                                                                                                rawValue: nil,
                                                                                                                label: nil,
                                                                                                                valueState: nil)),
                                                        buttons: [
                                                            UIModelDataAction("b1", "b1", .text),
                                                            UIModelDataAction("b2", "b2", .text)
                                                        ])).environmentObject(ThemeManager.shared)
        }
    }
#endif
