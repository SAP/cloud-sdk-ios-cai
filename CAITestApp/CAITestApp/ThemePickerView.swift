import SAPCAI
import SwiftUI

struct ThemePickerView: View {
    @Binding var selectedTheme: Int

    private let themes: [CAITheme] = [.fiori(FioriV6ColorPalette()), .casual(CasualColorPalette())]

    var body: some View {
        VStack {
            Picker(selection: Binding<Int>(get: {
                self.selectedTheme
            }, set: { value in
                self.selectedTheme = value
                let theme = self.themes[self.selectedTheme]
                ThemeManager.shared.setCurrentTheme(theme)
            }), label: Text("Theme")) {
                ForEach(0 ..< themes.count) {
                    Text(self.themes[$0].theme.name).tag($0)
                }
            }.pickerStyle(SegmentedPickerStyle())

            NavigationLink("View Colors", destination: ThemingView())
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    @State static var selectedTheme = 0

    static var previews: some View {
        ThemePickerView(selectedTheme: $selectedTheme)
    }
}
