import SwiftUI

struct StaticMenuView: View {
    @Binding var isMenuPresented: Bool
    
    var menuActions: [MenuAction]
    
    var menuTitle: String
    
    private var _linkMenuActions: [MenuAction]
    private var _postBackMenuActions: [MenuAction]
    private var _nestedMenuActions: [MenuAction]
    
    @EnvironmentObject private var viewModel: MessagingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(isMenuPresented: Binding<Bool>, menuActions: [MenuAction], menuTitle: String) {
        self._isMenuPresented = isMenuPresented
        self.menuActions = menuActions
        self.menuTitle = menuTitle
        self._linkMenuActions = menuActions.filter { $0.actionType == MenuActionType.link }
        self._postBackMenuActions = menuActions.filter { $0.actionType == MenuActionType.postBack }
        self._nestedMenuActions = menuActions.filter { $0.actionType == MenuActionType.nested }
    }
    
    var body: some View {
        List {
            Section {
                ForEach(self._linkMenuActions, id: \.actionId) { menuAction in
                    Button(action: {
                        self.viewModel.urlOpenerData.url = menuAction.value!
                        URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: menuAction.value!)
                        self.isMenuPresented = false
                    }, label: {
                        MenuUnnestedItem(menuAction: menuAction, iconName: "link")
                            .environmentObject(self.themeManager)
                    })
                }
            }
            Section {
                ForEach(self._postBackMenuActions, id: \.actionId) { menuAction in
                    Button(action: {
                        self.viewModel.postMessage(type: PostbackType.button, postbackData: UIModelDataAction(menuAction.menuTitle, menuAction.value!, .postback))
                        self.isMenuPresented = false
                    }, label: {
                        MenuUnnestedItem(menuAction: menuAction, iconName: "arrow.up.circle")
                            .environmentObject(self.themeManager)
                    })
                }
            }
            Section {
                ForEach(self._nestedMenuActions, id: \.actionId) { menuAction in
                    VStack {
                        if menuAction.menuActions != nil {
                            NavigationLink(destination: StaticMenuView(isMenuPresented: self.$isMenuPresented, menuActions: menuAction.menuActions!, menuTitle: menuAction.menuTitle)) {
                                HStack(alignment: .top, spacing: 10) {
                                    Text(menuAction.menuTitle)
                                        .lineLimit(1)
                                        .font(.headline)
                                        .foregroundColor(self.themeManager.color(for: .primary2))
                                        .padding([.top, .bottom], 10)
                                    Spacer()
                                    Text(String(menuAction.menuActions!.count))
                                        .lineLimit(1)
                                        .font(.headline)
                                        .foregroundColor(self.themeManager.color(for: .primary2))
                                        .padding([.top, .bottom], 10)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(self.menuTitle), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                self.isMenuPresented = false
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.gray)
            }))
    }
}

#if DEBUG
    struct StaticMenuView_Previews: PreviewProvider {
        static var previews: some View {
            StaticMenuView(isMenuPresented: .constant(false), menuActions: [CAIChannelMenuDataAction("Google", "Link", "https://www.google.com", nil)], menuTitle: "title").environmentObject(testData).environmentObject(ThemeManager.shared)
        }
    }
#endif
