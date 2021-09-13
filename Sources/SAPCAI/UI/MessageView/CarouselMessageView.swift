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
        let blankSpace = CGFloat(groupItemsCount + 1) * self.paddingLT + 2 * self.padding + self.trailPadding
        return (self.geometry.size.width - blankSpace) / CGFloat(self.groupItemsCount)
    }
    
    private var trailPadding: CGFloat {
        if self.horizontalSizeClass == .compact && self.verticalSizeClass == .regular {
            return 30
        } else {
            return 172
        }
    }
    
    private var groupItemsCount: Int {
        if self.horizontalSizeClass == .compact && self.verticalSizeClass == .regular {
            return 1
        } else {
            return 2
        }
    }
    
    private var contentOffset: CGFloat {
        let displayedIndex: Int
        if self.currentIndex > self.pageCount - self.groupItemsCount {
            displayedIndex = self.pageCount - self.groupItemsCount
        } else {
            displayedIndex = self.currentIndex
        }
        
        let pageOffset = (CGFloat(displayedIndex) * -(itemWidth + self.paddingLT)) + self.offset
        
        if displayedIndex == 0 {
            return pageOffset
        } else if self.currentIndex >= self.pageCount - self.groupItemsCount {
            return pageOffset + self.trailPadding
        } else {
            return pageOffset + (self.trailPadding / 2)
        }
    }
    
    var previousDisableBinding: Binding<Bool> {
        Binding { self.currentIndex == 0 || (self.currentIndex > pageCount - groupItemsCount && groupItemsCount == pageCount) } set: { _ in }
    }
    
    var nextDisableBinding: Binding<Bool> {
        Binding { self.currentIndex >= (self.pageCount - groupItemsCount) } set: { _ in }
    }
    
    var groupItemsCountBinding: Binding<Int> {
        Binding { groupItemsCount } set: { _ in }
    }
    
    var body: some View {
        if carousel?.carouselItems.count == 1,
           let uimodel = carousel?.carouselItems.first
        {
            CarouselItemView(carouselItem: uimodel, itemWidth: self.itemWidth)
                .frame(width: self.itemWidth, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: self.themeManager.value(for: .cornerRadius, type: CGFloat.self, defaultValue: 8)))
                .background(roundedBorder(for: self.themeManager.theme))
        } else {
            VStack(alignment: .leading, spacing: 0) {
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
                .offset(x: contentOffset)
                .animation(.easeInOut)
                .frame(width: geometry.size.width - 2 * self.padding, alignment: .leading)
                .clipped()
                
                CarouselPageControlView(currentIndex: $currentIndex, pageCount: pageCount,
                                        previousButtonDisabled: previousDisableBinding,
                                        nextButtonDisabled: nextDisableBinding,
                                        groupItemsCount: groupItemsCountBinding)
                    .frame(width: geometry.size.width - 2 * self.padding, height: 50)
            }
            .background(roundedBorder(for: self.themeManager.theme))
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / (itemWidth + paddingLT)
                        let roundIndex = progress.rounded()
                        if currentIndex > pageCount - groupItemsCount {
                            currentIndex = max(min(pageCount - groupItemsCount + Int(roundIndex), pageCount - groupItemsCount), 0)
                        } else {
                            currentIndex = max(min(currentIndex + Int(roundIndex), pageCount - groupItemsCount), 0)
                        }
                    }
            )
        }
    }
}

#if DEBUG
    struct CarouselMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                CarouselMessageView(model: PreviewData.carsoulMessageData, geometry: geometry)
                    .environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
