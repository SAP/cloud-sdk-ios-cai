import SwiftUI

struct CarouselItemView: View {
    var carouselItem: CarouselItemMessageData?
    
    var itemWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if carouselItem != nil {
                if carouselItem!.itemPicture != nil {
                    CarouselImageView(media: carouselItem!.itemPicture, itemWidth: itemWidth)
                }
                if carouselItem!.itemHeader != nil {
                    HeaderMessageView(model: carouselItem!.itemHeader!, listItemCount: nil, listTotal: nil)
                }
                if carouselItem!.itemButtons != nil {
                    CarouselButtonsView(buttonsData: carouselItem!.itemButtons)
                        .frame(minHeight: 44)
                        .buttonStyle(PlainCellButtonStyle())
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
