import SwiftUI

struct CarouselItemView: View {
    var carouselItem: CarouselItemMessageData?
    @EnvironmentObject private var viewModel: MessagingViewModel

    var itemWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let item = carouselItem {
                NavigationLink(destination: CarouselDetailPage(carouselItem: item)
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(self.viewModel)) {
                    VStack(spacing: 0) {
                        if let picture = item.itemPicture {
                            CarouselImageView(media: picture, itemWidth: itemWidth)
                        }
                        
                        if let headerModel = item.itemHeader {
                            HeaderMessageView(model: headerModel, listItemCount: nil, listTotal: nil)
                        }
                    }
                }
                if let buttonsData = item.itemButtons {
                    CarouselButtonsView(buttonsData: buttonsData)
                        .frame(minHeight: 44)
                }
            }
        }
    }
}

struct CarouselItemView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselItemView(carouselItem: nil, itemWidth: CGFloat(integerLiteral: 300))
    }
}
