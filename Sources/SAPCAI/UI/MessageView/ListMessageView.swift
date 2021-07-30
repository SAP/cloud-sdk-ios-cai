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

    @State private var showMoreListItems: Bool = false
    
    var body: some View {
        var showMoreLen = min(list!.items.count, 12)
        if let total = list?.listTotal {
            showMoreLen = min(list!.items.count, 12, total)
        }
        let showLessLen = min(list!.items.count, 6)
        
        return VStack(spacing: 0) {
            if self.showMoreListItems {
                if list!.listHeader != nil {
                    HeaderMessageView(model: list!.listHeader!, listItemCount: String(showMoreLen), listTotal: list?.listTotal)
                }
                ForEach(0 ..< showMoreLen, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        // each object card goes here
                        ObjectMessageView(model: self.list!.items[i])
                        if i < showMoreLen - 1 {
                            Divider().background(self.themeManager.color(for: .lineColor))
                        }
                    }
                }
            } else {
                if list!.listHeader != nil {
                    HeaderMessageView(model: list!.listHeader!, listItemCount: String(showLessLen), listTotal: list?.listTotal)
                }
                ForEach(0 ..< showLessLen, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        // each object card goes here
                        ObjectMessageView(model: self.list!.items[i])
                        if i < showLessLen - 1 {
                            Divider().background(self.themeManager.color(for: .lineColor))
                        }
                    }
                }
            }
            if list!.listUpperBoundText != nil && list!.items.count > 12 && self.showMoreListItems {
                Divider().background(self.themeManager.color(for: .lineColor))
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(list!.listUpperBoundText!)
                        .font(.body)
                        .padding(16)
                        .foregroundColor(themeManager.color(for: .primary2))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
            }
            // display only the first button
            if list!.listButtons != nil && !list!.listButtons!.isEmpty {
                Divider().background(self.themeManager.color(for: .lineColor))
                HStack(alignment: .top, spacing: 0) {
                    ButtonView(button: self.list!.listButtons![0], type: .button, buttonViewType: .menuSelectionButton)
                    Spacer()
                    if list!.items.count > 6 && !self.showMoreListItems {
                        Button(action: {
                            self.viewModel.contentHeight += 0
                            self.showMoreListItems = true
                        }, label: {
                            Text(Bundle.cai.localizedString(forKey: "View more", value: "View more", table: nil))
                                .font(.body)
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
        static var previews: some View {
            ListMessageView(model: testData.model[0])
        }
    }
#endif
