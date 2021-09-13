import SwiftUI

struct PageControl: View {
    @Binding var selectedIndex: Int
    @Binding var groupItemsCount: Int
    var pageCount: Int
    var circleDiameter: CGFloat = 3
    var circleMargin: CGFloat = 10

    var body: some View {
        ZStack {
            if groupItemsCount > 1 {
                HStack(spacing: circleMargin) {
                    ForEach(0 ..< pageCount) { _ in
                        Circle()
                            .fill(Color.gray)
                            .frame(width: circleDiameter, height: circleDiameter)
                    }
                }
                RoundedRectangle(cornerRadius: circleDiameter)
                    .fill(Color.blue)
                    .frame(width: circleWidth, height: 2 * circleDiameter)
                    .offset(x: currentPosition)
                    .animation(.spring())
            } else {
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
    
    var circleWidth: CGFloat {
        let groupCountFloat = CGFloat(groupItemsCount)
        return groupCountFloat * self.circleDiameter + (groupCountFloat - 1) * self.circleMargin
    }
    
    private var currentPosition: CGFloat {
        let showIndex = CGFloat(min(selectedIndex, pageCount - self.groupItemsCount))
        let stackWidth = self.circleDiameter * CGFloat(self.pageCount) + self.circleMargin * CGFloat(self.pageCount - 1)
        let halfStackWidth = stackWidth / 2
        let iniPosition = -halfStackWidth + self.circleDiameter / 2
        let distanceToNextPoint = self.circleDiameter + self.circleMargin
        return iniPosition + (showIndex * distanceToNextPoint) + self.circleWidth / 2 - self.circleDiameter / 2
    }
}

#if DEBUG
    struct PageControl_Previews: PreviewProvider {
        @State static var selectedIndex = 1
        static var previews: some View {
            PageControl(selectedIndex: $selectedIndex, groupItemsCount: .constant(1), pageCount: 4)
        }
    }
#endif
