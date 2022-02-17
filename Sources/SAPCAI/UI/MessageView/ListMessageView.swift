import SwiftUI

struct ListMessageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    var model: MessageData
    
    var list: ListMessageData? {
        if case .list(let data) = self.model.type {
            return data
        }
        return nil
    }

    var safeList: ListMessageData {
        self.list ?? UIModelData(type: "list")
    }

    var showBarRow: Bool {
        // to show first button (if there are any buttons for a list)
        if let listButtons = self.safeList.listButtons, listButtons.isEmpty == false {
            return true
        }
        // to show "View More" button (if there are more list items to show)
        if self.safeList.items.count > 6 && !self.showMoreListItems {
            return true
        }
        return false
    }

    @State private var showMoreListItems: Bool = false
    
    var body: some View {
        let listData = self.safeList

        var showMoreLen = min(listData.items.count, 12)
        if let total = listData.listTotal {
            showMoreLen = min(listData.items.count, 12, total)
        }
        let showLessLen = min(listData.items.count, 6)
        
        return VStack(spacing: 0) {
            if self.showMoreListItems {
                if let listHeader = listData.listHeader {
                    HeaderMessageView(model: listHeader, listItemCount: String(showMoreLen), listTotal: list?.listTotal)
                }
                ForEach(0 ..< showMoreLen, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        // each object card goes here
                        ListItemView(model: listData.items[i])
                        if i < showMoreLen - 1 {
                            Divider().background(self.themeManager.color(for: .lineColor))
                        }
                    }
                }
            } else {
                if let listHeader = listData.listHeader {
                    HeaderMessageView(model: listHeader, listItemCount: String(showLessLen), listTotal: list?.listTotal)
                }
                ForEach(0 ..< showLessLen, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        // each object card goes here
                        ListItemView(model: listData.items[i])
                        if i < showLessLen - 1 {
                            Divider().background(self.themeManager.color(for: .lineColor))
                        }
                    }
                }
            }
            if listData.listUpperBoundText != nil && listData.items.count > 12 && self.showMoreListItems {
                Divider().background(self.themeManager.color(for: .lineColor))
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(listData.listUpperBoundText!)
                        .font(Font.fiori(forTextStyle: .body))
                        .padding(16)
                        .foregroundColor(themeManager.color(for: .primary2))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
            }
            // display only the first button
            if self.showBarRow {
                Divider().background(self.themeManager.color(for: .lineColor))
                HStack(alignment: .top, spacing: 0) {
                    if let buttons = listData.listButtons, let firstButton = buttons.first {
                        ButtonView(button: firstButton, type: .button, buttonViewType: .menuSelectionButton)
                    }
                    Spacer()
                    if listData.items.count > 6 && !self.showMoreListItems {
                        Button(action: {
                            self.viewModel.contentHeight += 0
                            self.showMoreListItems = true
                        }, label: {
                            Text(Bundle.cai.localizedString(forKey: "View more", value: "View more", table: nil))
                                .font(Font.fiori(forTextStyle: .subheadline))
                                .lineLimit(1)
                                .padding(16)
                        })
                    }
                }
            }
        }
    }
}

#if DEBUG
    struct ListMessageView_Previews: PreviewProvider {
        static func previewData(items: Int, hasFooterButton: Bool) -> MessageData {
            var headerArr = [CAIResponseMessageData]()
            for n in 1 ... items {
                headerArr.append(CAIResponseMessageData(title: "MacBook \(n)", subtitle: "Computer", headerImageName: "sap-icon://desktop-mobile", status1: "Available", status1_state: .success, status2: "In Stock", isBot: true))
            }
            // swiftlint:disable:next line_length
            return CAIResponseMessageData(headerArr.map { $0.attachment.content! }, hasFooterButton ? [UIModelDataAction("Footer button", "Footer button", .text)] : [], "List of Products", "Electronics", "Sample Electronics", false)
        }

        static var previews: some View {
            Group {
                ListMessageView(model: ListMessageView_Previews.previewData(items: 2, hasFooterButton: false))
                    .environmentObject(ThemeManager.shared)
                    .previewDisplayName("Few items")
                    .previewLayout(.sizeThatFits)

                ListMessageView(model: ListMessageView_Previews.previewData(items: 2, hasFooterButton: true))
                    .environmentObject(ThemeManager.shared)
                    .previewDisplayName("Few items with footer")
                    .previewLayout(.sizeThatFits)

                ListMessageView(model: ListMessageView_Previews.previewData(items: 15, hasFooterButton: false))
                    .environmentObject(ThemeManager.shared)
                    .previewDisplayName("Lots of items items")
                    .previewLayout(.sizeThatFits)

                ListMessageView(model: ListMessageView_Previews.previewData(items: 15, hasFooterButton: true))
                    .environmentObject(ThemeManager.shared)
                    .previewDisplayName("Lots of items items with footer")
                    .previewLayout(.sizeThatFits)
            }
        }
    }
#endif
