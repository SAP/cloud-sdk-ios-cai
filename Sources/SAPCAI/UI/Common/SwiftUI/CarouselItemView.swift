import SwiftUI

struct CarouselItemView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel

    var carouselItem: CarouselItemMessageData?

    var itemWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let item = carouselItem {
                NavigationLink(destination: CarouselDetailPage(carouselItem: item)
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(self.viewModel)
                ) {
                    VStack(spacing: 0) {
                        if let picture = item.itemPicture {
                            CarouselImageView(media: picture, itemWidth: itemWidth)
                        }
                        
                        if let headerModel = item.itemHeader {
                            HeaderMessageView(model: headerModel, listItemCount: nil, listTotal: nil)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // needed for iOS 13 to avoid whole image will be be covered with an opaque blue color, see https://www.hackingwithswift.com/quick-start/swiftui/how-to-disable-the-overlay-color-for-images-inside-button-and-navigationlink
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
