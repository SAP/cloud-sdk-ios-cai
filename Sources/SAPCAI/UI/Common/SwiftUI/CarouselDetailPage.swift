import SwiftUI
import URLImage

struct CarouselDetailPage: View {
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
    
    var carouselItem: CarouselItemMessageData?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16) {
                    carouselHeaderImage
                    carouselHeader
                    Divider().background(self.themeManager.color(for: .lineColor))
                    carouselAttributesTable
                }
                Spacer().frame(height: 20)
            }
            Divider().background(self.themeManager.color(for: .lineColor))
            if let buttonsData = carouselItem?.itemButtons {
                CarouselButtonsView(buttonsData: buttonsData, actionBlock: {
                    presentationMode.wrappedValue.dismiss()
                })
                    .frame(minHeight: 44)
            }
        }
    }
    
    @ViewBuilder var carouselHeaderImage: some View {
        if let imgURL = carouselItem?.itemPicture?.sourceUrl {
            URLImage(url: imgURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: 180.0 / 375 * screenWidth)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
        }
    }
    
    @ViewBuilder var carouselHeader: some View {
        if let itemHeader = carouselItem?.itemHeader,
           let headline = itemHeader.headline,
           let subheadline = itemHeader.subheadline
        {
            VStack(alignment: .leading, spacing: 8) {
                Text(headline)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.leading, .trailing], 20)
        }
    }
    
    @ViewBuilder
    func makeGroupCells(group: [UIModelDataValue]) -> some View {
        HStack {
            ForEach(0 ..< group.count) { index in
                if let title = group[index].label,
                   let detail = group[index].value
                {
                    CarouselDetailInfoCell(title: title, detail: detail)
                        .frame(maxWidth: .infinity)
                        .clipped()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder var carouselAttributesTable: some View {
        if let sections = carouselItem?.itemSections,
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

struct CarouselDetailInfoCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let detail: String
    
    init(title: String,
         detail: String)
    {
        self.title = title
        self.detail = detail
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.title)
                .font(.subheadline)
                .foregroundColor(themeManager.color(for: .primary2))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(self.detail)
                .font(.subheadline)
                .foregroundColor(themeManager.color(for: .primary1))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
    struct CarouselDetailPage_Previews: PreviewProvider {
        static var previews: some View {
            CarouselDetailPage(carouselItem: PreviewData.carouselDetail)
                .environmentObject(ThemeManager.shared)
        }
    }
#endif
