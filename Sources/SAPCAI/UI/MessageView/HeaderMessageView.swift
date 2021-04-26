import SwiftUI

struct HeaderMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let model: HeaderMessageData
    
    var imageUrl: URL? {
        if let sUrl = model.imageUrl, let url = URL(string: sUrl) {
            return url
        }
        return nil
    }
    
    let listItemCount: String?
    let listTotal: Int?
    
    var total: String? {
        if let iTotal = listTotal {
            return String(iTotal)
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                if imageUrl != nil {
                    ImageView(imageUrl: imageUrl!)
                        .frame(width: 50, height: 50)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(model.headline ?? "-")
                        .lineLimit(1)
                        .font(.headline)
                        .foregroundColor(themeManager.color(for: .primary1))
                    Text(model.subheadline ?? "-")
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundColor(themeManager.color(for: .primary2))
                    if model.footnote != nil {
                        Text(model.footnote!)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(themeManager.color(for: .primary2))
                    }
                }
                Spacer()
                if listItemCount != nil && total != nil {
                    Text("\(listItemCount!) of \(total!)")
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundColor(themeManager.color(for: .primary2))
                }
            }
            .padding(16)

            Divider().background(self.themeManager.color(for: .lineColor))
        }
    }
}

#if DEBUG
    struct HeaderMessageView_Previews: PreviewProvider {
        static var previews: some View {
            HeaderMessageView(model: UIModelDataHeader(title: UIModelDataValue(value: "title1", dataType: UIModelData.ValueType.text.rawValue,
                                                                               rawValue: nil,
                                                                               label: nil,
                                                                               valueState: nil), subtitle: UIModelDataValue(value: "subtitle1", dataType: UIModelData.ValueType.text.rawValue,
                                                                                                                            rawValue: nil,
                                                                                                                            label: nil,
                                                                                                                            valueState: nil), description: nil), listItemCount: nil, listTotal: nil).environmentObject(ThemeManager.shared)
        }
    }
#endif
