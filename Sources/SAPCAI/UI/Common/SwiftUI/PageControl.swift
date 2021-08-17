import SwiftUI

struct PageControl: View {
    @Binding var selectedIndex: Int

    var pageCount: Int
    var circleDiameter: CGFloat = 3
    var circleMargin: CGFloat = 10
    
    var body: some View {
        ZStack {
            HStack(spacing: circleMargin) {
                ForEach(0 ..< pageCount) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.blue : Color.gray)
                        .frame(width: circleDiameter, height: circleDiameter)
                        .scaleEffect(index == selectedIndex ? 2 : 1)
                        .animation(.spring())
                }
            }
        }
    }
}

#if DEBUG
    struct PageControl_Previews: PreviewProvider {
        @State static var selectedIndex = 1
        static var previews: some View {
            PageControl(selectedIndex: $selectedIndex, pageCount: 4)
        }
    }
#endif
