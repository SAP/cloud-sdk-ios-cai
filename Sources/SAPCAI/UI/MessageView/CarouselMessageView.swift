import SwiftUI

struct CarouselMessageView: View {
    let model: MessageData
    let geometry: GeometryProxy
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    
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
        self.geometry.size.width - (self.paddingLT * 3)
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
            .content.offset(x: self.offset)
            .animation(.easeInOut)
            .background(Color(white: 0.9, opacity: 1))
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        self.offset = value.translation.width + self.calculateOffset()
                    }
                    .onEnded { value in
                        if abs(value.predictedEndTranslation.width) >= geometry.size.width / 2 {
                            var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                            nextIndex += self.currentIndex
                            self.currentIndex = nextIndex.keepIndexInRange(min: 0, max: self.pageCount - 1)
                        }
                        self.offset = self.calculateOffset()
                    }
            )
            
            CarouselPageControlView(currentIndex: $currentIndex, pageCount: pageCount)
                .frame(width: geometry.size.width, height: 50)
                .background(Color.white)
                .padding(.zero)
        }
        .padding([.leading, .trailing], 0 - padding)
        .onChange(of: currentIndex) { _ in
            self.offset = self.calculateOffset()
        }
    }
    
    func calculateOffset() -> CGFloat {
        let newOffset = -(geometry.size.width - 2 * self.paddingLT) * CGFloat(self.currentIndex)
        return self.currentIndex == self.pageCount - 1 ? (newOffset + self.padding) : newOffset
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
