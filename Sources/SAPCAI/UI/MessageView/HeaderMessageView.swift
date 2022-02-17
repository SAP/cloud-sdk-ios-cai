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
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 6) {
                        if let headline = model.headline {
                            Text(headline)
                                .lineLimit(1)
                                .font(Font.fiori(forTextStyle: .headline).weight(.bold))
                                .foregroundColor(themeManager.color(for: .primary1))
                        }
                        if let subheadline = model.subheadline {
                            Text(subheadline)
                                .lineLimit(1)
                                .font(Font.fiori(forTextStyle: .body))
                                .foregroundColor(themeManager.color(for: .primary2))
                        }
                        if let footnote = model.footnote {
                            Text(footnote)
                                .lineLimit(1)
                                .font(Font.fiori(forTextStyle: .subheadline))
                                .foregroundColor(themeManager.color(for: .primary2))
                        }
                    }
                    Spacer()

                    VStack(alignment: .trailing) {
                        if listItemCount != nil && total != nil {
                            Text("\(listItemCount!) of \(total!)")
                                .lineLimit(1)
                                .font(Font.fiori(forTextStyle: .subheadline))
                                .foregroundColor(themeManager.color(for: .primary2))
                        }
                        if let status = model.status {
                            ItemStatus(status: status)
                        }
                    }
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
            Group {
                HeaderMessageView(model: UIModelDataHeader(options: [.title, .subtitle, .description]),
                                  listItemCount: "5",
                                  listTotal: 10)
                    .previewDisplayName("List Header")

                HeaderMessageView(model: UIModelDataHeader(options: .all),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("Card Header")

                HeaderMessageView(model: UIModelDataHeader(options: .all),
                                  listItemCount: "5",
                                  listTotal: 10)
                    .previewDisplayName("Mixing List Info & Status will probably never happen")

                HeaderMessageView(model: UIModelDataHeader(options: [.title, .subtitle, .status1]),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("No Description")

                HeaderMessageView(model: UIModelDataHeader(options: [.title, .description, .status1]),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("No Subtitle")

                HeaderMessageView(model: UIModelDataHeader(options: [.title]),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("Only Title")

                HeaderMessageView(model: UIModelDataHeader(options: [.subtitle, .status1]),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("Subtitle and Status shall be on the same line if Title is missing")

                HeaderMessageView(model: UIModelDataHeader(options: [.description, .status1]),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("Description and Status shall be on the same line if Title & Subtitle are missing")

                HeaderMessageView(model: UIModelDataHeader(options: [.description]),
                                  listItemCount: nil,
                                  listTotal: nil)
                    .previewDisplayName("Only Description")
            }
            .environmentObject(ThemeManager.shared)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
