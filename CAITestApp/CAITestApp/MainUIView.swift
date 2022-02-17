import FioriThemeManager
import SAPCAI
import SwiftUI

struct MainUIView: View {
    @ObservedObject private var dataModel = DataModel()
    
    var body: some View {
        Group {
            HomeView(dataModel: dataModel)
            // FioriColorPaletteView()
        }
    }
}

struct MainUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainUIView()
    }
}
