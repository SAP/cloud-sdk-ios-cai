import SwiftUI

struct CarouselPageControlView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var currentIndex: Int
    let pageCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Divider().background(self.themeManager.color(for: .lineColor))
            Spacer()
            HStack {
                Button {
                    if self.currentIndex > 0 {
                        self.currentIndex -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .font(.system(size: 30, weight: .thin))
                        .frame(width: 30, height: 30)
                }
                Spacer()
                PageControl(selectedIndex: $currentIndex, pageCount: self.pageCount)
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
            }
            .padding([.leading, .trailing], 50)
            Spacer()
            Divider().background(self.themeManager.color(for: .lineColor))
        }
    }
}

#if DEBUG
    struct CarouselPageControlView_Previews: PreviewProvider {
        @State static var selectedIndex = 1
        static var previews: some View {
            CarouselPageControlView(currentIndex: $selectedIndex, pageCount: 5)
        }
    }
#endif
