import SwiftUI

struct CarouselMessageView: View {
    let model: MessageData
    let geometry: GeometryProxy
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    
    @State private var currentIndex: Int = 0
    @GestureState private var offset: CGFloat = 0
    
    var carousel: CarouselMessageData? {
        if case .carousel(let data) = self.model.type {
            return data
        }
        return nil
    }
    
    var pageCount: Int {
        guard let carousel = carousel else {
            return 0
        }
        return carousel.carouselItems.count
    }
    
    private var padding: CGFloat {
        self.themeManager.value(for: .containerLTPadding, type: CGFloat.self, defaultValue: 0)
    }
    
    private var paddingTB: CGFloat {
        if self.horizontalSizeClass == .compact && self.verticalSizeClass == .regular {
            return 16
        } else if self.horizontalSizeClass == .regular && self.verticalSizeClass == .compact {
            return 10
        } else if self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular {
            return 16
        } else if self.horizontalSizeClass == .compact && self.verticalSizeClass == .compact {
            return 10
        }
        return 10
    }
    
    private var paddingLT: CGFloat {
        if self.horizontalSizeClass == .compact && self.verticalSizeClass == .regular {
            return 16
        } else if self.horizontalSizeClass == .regular && self.verticalSizeClass == .compact {
            return 20
        } else if self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular {
            return 20
        } else if self.horizontalSizeClass == .compact && self.verticalSizeClass == .compact {
            return 16
        }
        return 16
    }
    
    private var itemWidth: CGFloat {
        self.geometry.size.width - (self.paddingLT * 2) - self.trailPadding
    }
    
    private var trailPadding: CGFloat {
        if self.horizontalSizeClass == .compact && self.verticalSizeClass == .regular {
            return 30
        } else {
            return 228
        }
    }
    
    private var contentOffset: CGFloat {
        let pageOffset = (CGFloat(currentIndex) * -(itemWidth + self.paddingLT)) + self.offset
        if self.currentIndex == 0 {
            return pageOffset
        } else if self.currentIndex == self.pageCount - 1 {
            return pageOffset + self.trailPadding
        } else {
            return pageOffset + (self.trailPadding / 2)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: paddingLT) {
                    ForEach(carousel!.carouselItems, id: \.id) { uimodel in
                        CarouselItemView(carouselItem: uimodel, itemWidth: self.itemWidth)
                            .frame(width: self.itemWidth, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: self.themeManager.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 8)))
                            .background(roundedBorder(for: self.themeManager.theme))
                    }
                }
                .padding([.leading, .trailing], paddingLT)
                .padding([.top, .bottom], paddingTB)
            }
            .content.offset(x: contentOffset)
            .animation(.easeInOut)
            .background(Color(white: 0.9, opacity: 1))
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / (itemWidth + paddingLT)
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), pageCount - 1), 0)
                    }
            )
            
            CarouselPageControlView(currentIndex: $currentIndex, pageCount: pageCount)
                .frame(width: geometry.size.width, height: 50)
                .background(Color.white)
                .padding(.zero)
        }
        .padding([.leading, .trailing], 0 - padding)
    }
}

#if DEBUG
    struct CarouselMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                CarouselMessageView(model: testData.model[0], geometry: geometry)
            }
        }
    }
#endif
