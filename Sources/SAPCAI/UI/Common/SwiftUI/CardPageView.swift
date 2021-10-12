import SwiftUI

struct CardPageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.presentationMode) private var presentationMode
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }

    let padding: CGFloat = 20
    let hStackSpacing: CGFloat = 8
    var minTextWidth: CGFloat {
        (self.screenWidth - 2 * self.padding - self.hStackSpacing) / 2
    }
    
    var card: CardMessageData?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16) {
                    featuredImage
                    header
                    Divider().background(self.themeManager.color(for: .lineColor))
                    attributesTable
                }
                Spacer().frame(height: 20)
            }
            if let buttonsData = card?.cardButtons, buttonsData.count > 0 {
                Divider().background(self.themeManager.color(for: .lineColor))
                CardPageButtonsView(buttonsData: buttonsData, actionBlock: {
                    presentationMode.wrappedValue.dismiss()
                })
                    .frame(minHeight: 44)
            }
        }
    }
    
    @ViewBuilder var featuredImage: some View {
        if let imgURL = card?.featuredImage?.sourceUrl {
            ImageViewWrapper(url: imgURL) { image in
                image
                    .scaledToFill()
                    .frame(width: screenWidth, height: 180.0 / 375 * screenWidth)
                    .clipped()
            }
        }
    }
    
    @ViewBuilder var header: some View {
        if let itemHeader = card?.cardHeader,
           let headline = itemHeader.headline,
           let subheadline = itemHeader.subheadline
        {
            HStack(alignment: .top) {
                if let imageUrl = itemHeader.imageUrl,
                   let imageURL = URL(string: imageUrl)
                {
                    ImageView(imageUrl: imageURL)
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(headline)
                            .font(.headline)
                            .foregroundColor(themeManager.color(for: .primary1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        statusView
                    }
                    Text(subheadline)
                        .font(.body)
                        .foregroundColor(themeManager.color(for: .primary1))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let carouselDesc = card?.cardHeader?.footnote {
                        Text(carouselDesc)
                            .font(.subheadline)
                            .foregroundColor(themeManager.color(for: .primary2))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
    }
    
    @ViewBuilder
    func makeGroupCells(group: [UIModelDataValue]) -> some View {
        HStack {
            ForEach(0 ..< group.count) { index in
                if let attribute = group[index] {
                    CardSectionAttributeView(sectionAttribute: attribute)
                        .frame(maxWidth: .infinity)
                        .clipped()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder var attributesTable: some View {
        if let sections = card?.cardSections,
           !sections.isEmpty,
           let attributeTitle = sections[0].title,
           let attributes = sections[0].attributes
        {
            let groupedAttributes = convertAttributes(attributes)
            Text(attributeTitle)
                .font(.headline)
                .padding([.leading, .trailing], 20)
            
            VStack(spacing: 16) {
                ForEach(groupedAttributes) {
                    makeGroupCells(group: $0.datas)
                }
            }
            .padding([.leading, .trailing], 20)
        } else {
            EmptyView()
//            VStack(alignment: .center) {
//                Image(systemName: "info.circle")
//                Text("No detailed content available")
//            }
//            .font(.headline)
//            .foregroundColor(themeManager.color(for: .primary1))
//            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder var statusView: some View {
        if let status = card?.cardHeader?.status {
            ItemStatus(status: status)
        }
    }
    
    struct ModelsContainer: Identifiable {
        let id = UUID()
        var datas: [UIModelDataValue]
    }
    
    func convertAttributes(_ attributes: [UIModelDataValue]) -> [ModelsContainer] {
        var groupedAttributes: [ModelsContainer] = []
        var pairedAttributes = ModelsContainer(datas: [])
        var startNewPaired = true
        
        for (index, item) in attributes.enumerated() {
            if let label = item.label, let value = item.value {
                if self.shouldAddNewLine(for: label) || self.shouldAddNewLine(for: value) {
                    if startNewPaired {
                        groupedAttributes.append(ModelsContainer(datas: [item]))
                    } else {
                        groupedAttributes.append(pairedAttributes)
                        groupedAttributes.append(ModelsContainer(datas: [item]))
                        startNewPaired = true
                    }
                    pairedAttributes = ModelsContainer(datas: [])
                } else {
                    if startNewPaired {
                        pairedAttributes = ModelsContainer(datas: [])
                        pairedAttributes.datas.append(item)
                        startNewPaired = false
                        if index == attributes.count - 1 {
                            groupedAttributes.append(pairedAttributes)
                        }
                    } else {
                        pairedAttributes.datas.append(item)
                        groupedAttributes.append(pairedAttributes)
                        startNewPaired = true
                    }
                }
            }
        }
        return groupedAttributes
    }
    
    func shouldAddNewLine(for text: String) -> Bool {
        let uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
        let textSize = text.boundingRect(with: CGSize(width: self.minTextWidth, height: CGFloat.greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: uiFont], context: nil)
        let charSize = uiFont.lineHeight
        let linesRoundedUp = Int(ceil(textSize.height / charSize))
        return linesRoundedUp > 1
    }
}

struct CardSectionAttributeView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    let sectionAttribute: ValueData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.sectionAttribute.label ?? "")
                .font(.subheadline)
                .foregroundColor(themeManager.color(for: .primary2))
                .frame(maxWidth: .infinity, alignment: .leading)

            if sectionAttribute.isClickable {
                Button(action: {
                    self.viewModel.urlOpenerData.url = self.sectionAttribute.formattedValue
                    URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: self.sectionAttribute.formattedValue)
                }, label: {
                    Text(self.sectionAttribute.value!)
                        .font(.subheadline)
                        .foregroundColor(themeManager.color(for: .accentColor))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                })
            } else {
                Text(self.sectionAttribute.formattedValue)
                    .font(.subheadline)
                    .foregroundColor(themeManager.color(for: .primary1))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#if DEBUG
    struct CardPageView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CardPageView(card: PreviewData.objectMessage.first!)

                CardPageView(card: PreviewData.carouselDetail)

                CardPageView(card: PreviewData.card(title: true, subtitle: true, image: .init(type: .regular, placement: .content), status: true))

                CardPageView(card: PreviewData.card(title: true, subtitle: true, image: .init(type: .icon, placement: .header), status: true))

                CardPageView(card: PreviewData.card(title: true, subtitle: true, image: nil, status: true))
            }
            .environmentObject(testData)
            .environmentObject(ThemeManager.shared)
        }
    }
#endif
