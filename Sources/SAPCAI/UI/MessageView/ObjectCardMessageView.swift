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
                        if model.headline != nil {
                            Text(model.headline!)
                                .font(.headline)
                                .foregroundColor(themeManager.color(for: .primary1))
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if model.subheadline != nil {
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
                    
                    VStack(alignment: .trailing) {
                        if model.status != nil, model.status!.value != nil {
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
                        if model.substatus != nil {
                            Text(model.substatus!)
                                .font(.subheadline)
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
            ObjectCardMessageView(model: UIModelDataContent(text: "text1", list: nil, form: nil, picture: nil, video: nil,
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
