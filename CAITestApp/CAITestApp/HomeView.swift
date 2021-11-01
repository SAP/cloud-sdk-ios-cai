import SAPCAI
import SwiftUI

struct HomeView: View {
    enum TestDataType: Int, RawRepresentable, CaseIterable {
        case `static` = 0
        case live = 1
    }

    enum ViewRepresentation: Int, RawRepresentable {
        case fullscreen = 0
        case modal = 1
    }

    enum ChannelSelection: Int, RawRepresentable {
        case appId = 0
        case token = 1
    }

    enum ConversationType: Int, RawRepresentable {
        case new = 0
        case existing = 1
    }

    @State private var selectedTestDataType: TestDataType = .static

    @State private var selectedTheme = 0

    @State private var selectedConnectionIndex: Int = 0 {
        didSet {
            if self.clients.count > self.selectedConnectionIndex {
                self.liveConnection.update(basedOn: self.clients[self.selectedConnectionIndex])
            }
        }
    }

    @State private var selectedViewRepresentation: ViewRepresentation = .fullscreen

    @State private var selectedChannelSelection: ChannelSelection = .appId

    @State private var isPresented = false

    @ObservedObject private var liveConnection = Connection()

    var clients: [Connection] = []

    let dataModel: DataModel

    init(dataModel: DataModel) {
        self.dataModel = dataModel
        self.selectedConnectionIndex = 0

        if let url = Bundle.main.url(forResource: "Connections", withExtension: "plist") {
            if let data = try? Data(contentsOf: url) {
                self.clients = try! PropertyListDecoder().decode([Connection].self, from: data)
            }
            self.clients.forEach { client in
                if let savedConnection = Connection.loadFromUserDefaults(with: client.name) {
                    client.update(basedOn: savedConnection)
                }
            }
        }
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 28)]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Theme")
                        ThemePickerView(selectedTheme: $selectedTheme)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Section(header: Text("Representation")) {
                            Picker(selection: Binding<ViewRepresentation>(get: {
                                self.selectedViewRepresentation
                            }, set: { value in
                                self.selectedViewRepresentation = value
                                if value == .modal {
                                    self.selectedTestDataType = .static
                                }
                            }), label: Text("Representation")) {
                                Text("Fullscreen").tag(ViewRepresentation.fullscreen)
                                Text("Modal").tag(ViewRepresentation.modal)
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Data")
                        Picker(selection: Binding<TestDataType>(get: {
                            self.selectedTestDataType
                        }, set: { value in
                            self.selectedTestDataType = value
                            if value == .live {
                                self.selectedViewRepresentation = .fullscreen
                                self.selectedConnectionIndex = 0
                            }
                        }), label: Text("Data")) {
                            Text("Static").tag(TestDataType.static)
                            if self.selectedViewRepresentation == .fullscreen {
                                Text("Live").tag(TestDataType.live)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }

                    if self.selectedTestDataType == TestDataType.live {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Connection")
                            Picker(selection: Binding<Int>(get: {
                                self.selectedConnectionIndex
                            }, set: { value in
                                self.selectedConnectionIndex = value
                                self.liveConnection.update(basedOn: clients[self.selectedConnectionIndex])
                            }), label: Text("Connection")) {
                                ForEach(0 ..< self.clients.count) { i in
                                    Text(self.clients[i].name).tag(i)
                                }
                            }.pickerStyle(SegmentedPickerStyle())

                            if clients[self.selectedConnectionIndex].name == "Custom" {
                                EditableConnectionView(model: liveConnection)
                            }

                            Text("Channel")
                            Picker(selection: Binding<ChannelSelection>(get: {
                                self.selectedChannelSelection
                            }, set: { value in
                                self.selectedChannelSelection = value
                            }), label: Text("Channel")) {
                                Text("Via AppId").tag(ChannelSelection.appId)
                                Text("Explicit").tag(ChannelSelection.token)
                            }.pickerStyle(SegmentedPickerStyle())

                            if self.selectedChannelSelection == ChannelSelection.token {
                                VStack {
                                    FloatingTextField(title: "Channel ID", text: $liveConnection.channelId, placeholder: "Channel ID")
                                    FloatingTextField(title: "Channel Token", text: $liveConnection.channelToken, placeholder: "Channel Token")
                                    FloatingTextField(title: "Channel Slug", text: $liveConnection.channelSlug, placeholder: "Channel Slug")
                                    FloatingTextField(title: "Existing Conversation Id", text: $liveConnection.conversationId, placeholder: "Existing Conversation Id")

                                }.padding()
                            }
                        }
                    }

                    connectButton

                    Spacer()

                    Image("SAPLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 32, alignment: .center)
                }
                .padding(10)
                .navigationBarTitle("Testing SAPCAI SDK for iOS")
                .onAppear {
                    self.dataModel.clear()
                }
            }
        }
        .sheet(isPresented: self.$isPresented, onDismiss: {
            self.isPresented = false
        }, content: {
            NavigationView {
                AssistantView().navigationBarTitle(Text("Chat"), displayMode: .inline)
                    .navigationBarItems(trailing: Button("Done", action: {
                        self.isPresented = false
                    }))
                    .environmentObject(MockData.viewModel)
                    .environmentObject(ThemeManager.shared)
            }.navigationViewStyle(StackNavigationViewStyle())

        })
        .navigationViewStyle(StackNavigationViewStyle())
    }

    @ViewBuilder var connectButton: some View {
        if self.selectedTestDataType == TestDataType.live {
            if self.selectedChannelSelection == ChannelSelection.token {
                NavigationLink(destination: NavigationLazyView(AssistantView()
                        .navigationBarTitle(Text(self.liveConnection.channelSlug), displayMode: .inline)
                        .environmentObject(self.dataModel.getModelFor(self.liveConnection))
                        .environmentObject(ThemeManager.shared)
                )) {
                    Text("Connect")
                }
            } else {
                connectButtonForChannelList()
            }
        } else {
            if self.selectedViewRepresentation == ViewRepresentation.fullscreen {
                NavigationLink(destination:
                    NavigationLazyView(
                        AssistantView().navigationBarTitle(Text("Chat"), displayMode: .inline)
                            .environmentObject(MockData.viewModel)
                            .environmentObject(ThemeManager.shared))
                ) {
                    Text("Connect")
                }
            }
            if self.selectedViewRepresentation == ViewRepresentation.modal {
                Button("Connect") {
                    self.isPresented = true
                }
            }
        }
    }

    func connectButtonForChannelList() -> AnyView {
        do {
            let config = try CAIServiceConfig.create(from: self.liveConnection)

            return AnyView(NavigationLink(destination:
                NavigationLazyView(
                    ChannelListView(CAIChannelService(config: config))
                        .environmentObject(self.dataModel)
                        .environmentObject(ThemeManager.shared))
            ) {
                Text("Connect")
            })
        } catch {
            return AnyView(Text("Enter correct URLs").foregroundColor(.red))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataModel: DataModel())
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        self.build()
    }
}
