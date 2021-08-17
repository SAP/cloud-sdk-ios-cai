import SwiftUI
import URLImage

struct CarouselDetailPage: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.presentationMode) private var presentationMode
    
    let screenWidth = UIScreen.main.bounds.size.width
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
            VStack(alignment: .leading) {
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
    func makeGroupCells(group: [UIModelDataValue], lineLimit: Int? = 1) -> some View {
        HStack {
            ForEach(0 ..< group.count) { index in
                if let title = group[index].label,
                   let detail = group[index].value
                {
                    CarouselDetailInfoCell(title: title, detail: detail, lineLimit: lineLimit)
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
                ForEach(0 ..< groupedAttributes.count) { index in
                    makeGroupCells(group: groupedAttributes[index], lineLimit: index < 3 ? 1 : nil)
                }
            }
            .padding([.leading, .trailing], 20)
        }
    }
    
    func convertAttributes(_ attributes: [UIModelDataValue]) -> [[UIModelDataValue]] {
        var groupedAttributes: [[UIModelDataValue]] = []
        var pairedAttributes: [UIModelDataValue] = []
        for (index, item) in attributes.enumerated() {
            if index < 6 {
                if index.isMultiple(of: 2) {
                    pairedAttributes = []
                    pairedAttributes.append(item)
                    if index == attributes.count - 1 {
                        groupedAttributes.append(pairedAttributes)
                    }
                } else {
                    pairedAttributes.append(item)
                    groupedAttributes.append(pairedAttributes)
                }
            } else {
                groupedAttributes.append([item])
            }
        }
        return groupedAttributes
    }
}

struct CarouselDetailInfoCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var viewModel: MessagingViewModel
    
    let title: String
    let detail: String
    let lineLimit: Int?
    
    init(title: String,
         detail: String,
         lineLimit: Int? = nil)
    {
        self.title = title
        self.detail = detail
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.title)
                .font(.subheadline)
                .foregroundColor(themeManager.color(for: .primary2))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(self.detail)
                .font(.subheadline)
                .foregroundColor(themeManager.color(for: .primary1))
                .lineLimit(lineLimit)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#if DEBUG
    struct CarouselDetailPage_Previews: PreviewProvider {
        static var previews: some View {
            CarouselDetailPage(carouselItem: PreviewData.carsoulDetail)
                .environmentObject(ThemeManager.shared)
        }
    }
#endif
