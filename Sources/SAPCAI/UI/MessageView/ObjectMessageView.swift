import SwiftUI

struct ObjectMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    let model: ObjectMessageData
    
    var imageUrl: URL? {
        if let sUrl = model.imageUrl, let url = URL(string: sUrl) {
            return url
        }
        return nil
    }
    
    private var isPortrait: Bool {
        self.hSizeClass == .compact && self.vSizeClass == .regular
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
                VStack(alignment: .leading, spacing: 6) {
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
                            .frame(minWidth: 99, maxWidth: self.isPortrait ? 100 : 200, alignment: .trailing)
                    } else {
                        MultiButtonsView(buttons: self.model.objectButtons!)
                    }
                } else {
                    VStack(alignment: .trailing, spacing: 6) {
                        if self.hasStatus, let status = model.status {
                            ItemStatus(status: status)
                        }
                        if self.hasButtons {
                            if model.objectButtons!.count == 1 {
                                QuickReplyButtonView(button: self.model.objectButtons![0], postbackType: .button)
                                    .frame(minWidth: 99, maxWidth: self.isPortrait ? 100 : 200, alignment: .trailing)
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
            Group {
                ObjectMessageView_Previews.imageWithTtitleAndButtonPreview
                    .previewLayout(.sizeThatFits)
                ObjectMessageView_Previews.imageWithTtitleAndButtonPreview
                    .previewLayout(.fixed(width: 800, height: 300))
            }
        }
        
        static var imageWithTtitleAndButtonPreview: some View {
            VStack {
                ForEach(PreviewData.objectMessage, id: \.id) { data in
                    VStack(alignment: .leading, spacing: 0) {
                        ObjectMessageView(model: data).environmentObject(ThemeManager.shared)
                        Divider().background(Color.black)
                    }
                }
            }
        }
    }
#endif
