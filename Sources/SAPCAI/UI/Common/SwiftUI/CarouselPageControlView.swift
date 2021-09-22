import SwiftUI

struct CarouselPageControlView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var currentIndex: Int
    let pageCount: Int
    @Binding var previousButtonDisabled: Bool
    @Binding var nextButtonDisabled: Bool
    @Binding var groupItemsCount: Int

    var body: some View {
        VStack(spacing: 0) {
            Divider().background(self.themeManager.color(for: .lineColor))
            Spacer()
            HStack {
                Button {
                    if self.currentIndex > 0 {
                        if currentIndex > pageCount - groupItemsCount {
                            self.currentIndex = pageCount - groupItemsCount - 1
                        } else {
                            self.currentIndex -= 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .font(.system(size: 30, weight: .thin))
                        .frame(width: 30, height: 30)
                }
                .disabled(previousButtonDisabled)
                Spacer()
                PageControl(selectedIndex: $currentIndex, groupItemsCount: $groupItemsCount, pageCount: self.pageCount)
                Spacer()
                Button {
                    if self.currentIndex < self.pageCount - 1 {
                        self.currentIndex += 1
                    }
                } label: {
                    Image(systemName: "chevron.right.circle")
                        .resizable()
                        .font(.system(size: 30, weight: .thin))
                        .frame(width: 30, height: 30)
                }
                .disabled(nextButtonDisabled)
            }
            .padding([.leading, .trailing], 50)
            Spacer()
        }
    }
}

#if DEBUG
    struct CarouselPageControlView_Previews: PreviewProvider {
        @State static var selectedIndex = 1
        static var previews: some View {
            CarouselPageControlView(currentIndex: $selectedIndex,
                                    pageCount: 5,
                                    previousButtonDisabled: .constant(false),
                                    nextButtonDisabled: .constant(false),
                                    groupItemsCount: .constant(1))
                .environmentObject(ThemeManager.shared)
        }
    }
#endif
