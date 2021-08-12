import SwiftUI

struct CarouselMessageView: View {
    let model: MessageData
    let geometry: GeometryProxy
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?

    var carousel: CarouselMessageData? {
        if case .carousel(let data) = self.model.type {
            return data
        }
        return nil
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
        if self.horizontalSizeClass == .compact && self.verticalSizeClass == .regular {
            return self.geometry.size.width - (self.paddingLT * 3)
        } else if self.horizontalSizeClass == .regular && self.verticalSizeClass == .compact {
            return 200
        } else if self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular {
            return 343
        } else if self.horizontalSizeClass == .compact && self.verticalSizeClass == .compact {
            return 200
        }
        return self.geometry.size.width - (self.paddingLT * 3)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
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
        .background(themeManager.color(for: .primary5))
        .padding([.leading, .trailing], 0 - padding) // bring the scrollview edge to edge
    }
}

#if DEBUG
    struct CarouselMessageView_Previews: PreviewProvider {
        static var previews: some View {
            GeometryReader { geometry in
                CarouselMessageView(model: PreviewData.carouselMessageData.model[0], geometry: geometry)
                    .environmentObject(ThemeManager.shared)
            }
        }
    }
#endif
