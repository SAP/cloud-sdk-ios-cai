import SwiftUI

/// Menu View that lists the menu actions
struct MenuButtonView: View {
    @EnvironmentObject private var viewModel: MessagingViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var isMenuPresented = false
    
    /// Menu actions represents all menu actions with different types (list, postback and nested)
    var menuActions: [MenuAction]
    
    var body: some View {
        Button(action: {
            self.isMenuPresented = true
        }, label: {
            Image(systemName: "list.bullet")
                .resizable()
                .frame(width: 20, height: 20)
        })
            .sheet(isPresented: self.$isMenuPresented, onDismiss: {
                self.isMenuPresented = false
            }) {
                NavigationView {
                    StaticMenuView(isMenuPresented: self.$isMenuPresented, menuActions: self.menuActions, menuTitle: "Quick Actions")
                        .environmentObject(self.viewModel)
                        .environmentObject(self.themeManager)
                }.navigationViewStyle(StackNavigationViewStyle())
            }
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(menuActions: [CAIChannelMenuDataAction("Google", "Link", "https://www.google.com", nil)]).environmentObject(testData).environmentObject(ThemeManager.shared)
    }
}
