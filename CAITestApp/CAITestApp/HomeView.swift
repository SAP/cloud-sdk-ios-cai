import FioriThemeManager
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

        // UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 28)]

        // largeTitle with 72 fonts is
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.preferredFioriColor(forStyle: .primaryLabel), .font: UIFont.preferredFioriFont(forTextStyle: .largeTitle, weight: .black)]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    // NavigationLink("Choose Colors", destination: ThemingView())

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

                            if self.selectedChannelSelection == ChannelSelection.appId {
                                Text("*Note: Channel Search via AppId does not work with SAP Conversational AI Community Edition. Use \"Explict\" in such case*. ")
                            }

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
                .navigationBarTitle("SAPCAI SDK for iOS")
                // .font(Font.fiori(forTextStyle: .largeTitle))
                .onAppear {
                    self.dataModel.clear()
                }
            }
        }
        .sheet(isPresented: self.$isPresented, onDismiss: {
            self.isPresented = false
        }, content: {
            NavigationView {
                AssistantView().navigationBarTitle(Text("Chat"), displayMode: .inline) // TODO: .large
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
                        AssistantView().navigationBarTitle(Text("Chat"), displayMode: .inline) // TODO: large
                            .environmentObject(MockData.viewModel)
                            .environmentObject(ThemeManager.shared)
                    )
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

// ONLY FOR THIS TEST APP
// The following code is NOT needed in apps built with SAPFiori.xcframework as such methods are available there
// Introduced as `UINavigationBar.appearance().largeTitleTextAttributes` expects UIKit-based representations of color and font
private extension UIColor {
    static func preferredFioriColor(forStyle style: ColorStyle) -> UIColor {
        let color = Color.preferredColor(style)
        let uiColor = UIColor(color)
        return uiColor
    }
}

private extension UIFont {
    class func preferredFioriFont(forTextStyle textStyle: UIFont.TextStyle, weight: UIFont.Weight = .regular, isItalic: Bool = false, isCondensed: Bool = false) -> UIFont {
        guard var font = UIFont(name: get72FontName(weight: weight.fioriWeight), size: textStyle.size) else {
            var font = UIFont.preferredFont(forTextStyle: textStyle).withWeight(weight)

            if isItalic {
                font = font.italic
            }
//            if isCondensed {
//                font = font.with(.traitCondensed)
//            }

            return font
        }

        let metrics: UIFontMetrics
//        if textStyle == .KPI || textStyle == .largeKPI {
//            metrics = UIFontMetrics(forTextStyle: .largeTitle)
//        } else {
        metrics = UIFontMetrics(forTextStyle: textStyle)
//        }

        if isItalic {
            font = font.italic
        }
//        if isCondensed {
//            font = font.with(.traitCondensed)
//        }

        let scaledFont = metrics.scaledFont(for: font)

        return scaledFont
    }

    class func preferredFioriFont(fixedSize size: CGFloat, weight: UIFont.Weight = .regular, isItalic: Bool = false, isCondensed: Bool = false) -> UIFont {
        guard var font = UIFont(name: get72FontName(weight: weight.fioriWeight), size: size) else {
            var font = UIFont.systemFont(ofSize: size, weight: weight)

            if isItalic {
                font = font.italic
            }
            if isCondensed {
                font = font.with(.traitCondensed)
            }

            return font
        }

        if isItalic {
            font = font.italic
        }
        if isCondensed {
            font = font.with(.traitCondensed)
        }

        return font
    }

    static func get72FontName(weight: UIFont.Weight) -> String {
        let description = weight.description

        // TODO: waiting for designer to update font name in 72-black.ttf
        if weight == .black {
            return "72\(description)"
        }

        return "72-\(description)"
    }
}

private extension UIFont {
    var bold: UIFont {
        self.with(.traitBold)
    }

    var italic: UIFont {
        self.with(.traitItalic)
    }

    var boldItalic: UIFont {
        self.with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}

private extension UIFont.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
//        case .largeKPI:
//            return 48
//        case .KPI:
//            return 36
        default:
            return 17
        }
    }
}

extension UIFont.TextStyle: CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        switch self {
        case .largeTitle:
            return "largeTitle"
        case .title1:
            return "title1"
        case .title2:
            return "title2"
        case .title3:
            return "title3"
        case .headline:
            return "headline"
        case .body:
            return "body"
        case .callout:
            return "callout"
        case .subheadline:
            return "subheadline"
        case .footnote:
            return "footnote"
        case .caption1:
            return "caption1"
        case .caption2:
            return "caption2"
//        case .KPI:
//            return "KPI"
//        case .largeKPI:
//            return "largeKPI"
        default:
            return "Unknown"
        }
    }
}

extension UIFont.Weight: CaseIterable, CustomStringConvertible {
    /// :nodoc:
    public static var allCases: [UIFont.Weight] {
        [.black, .heavy, .bold, .semibold, .medium, .regular, .light, .thin, .ultraLight]
    }

    /// :nodoc:
    public var description: String {
        let name: String

        switch self {
        case .black:
            name = "black"
        case .heavy:
            name = "heavy"
        case .bold:
            name = "bold"
        case .semibold:
            name = "semibold"
        case .medium:
            name = "medium"
        case .regular:
            name = "regular"
        case .light:
            name = "light"
        case .thin:
            name = "thin"
        case .ultraLight:
            name = "ultraLight"
        default:
            name = "Unknown"
        }

        return name
    }
}

private extension UIFont.Weight {
    // Available 72 weights
    var fioriWeight: UIFont.Weight {
        switch self {
        case .heavy, .black:
            return .black
        case .medium, .semibold, .bold:
            return .bold
        case .regular:
            return .regular
        case .ultraLight, .thin, .light:
            return .light
        default:
            return .regular
        }
    }
}

private extension UIFontDescriptor {
    internal class func preferredFioriDescriptor(textStyle: String) -> UIFontDescriptor {
        enum Static {
            static var fontNameTable = [String: String]()
            static var fontSizeTable = [String: [String: Int]]()
            static var fontWeightTable = [String: String]()
        }

        enum KPINumber1Size {
            static let xsmall = Int(42)
            static let small = Int(44)
            static let medium = Int(46)
            static let large = Int(48)
            static let xlarge = Int(50)
            static let xxlarge = Int(52)
            static let xxxlarge = Int(54)
        }

        enum KPINumber2Size {
            static let xsmall = Int(29)
            static let small = Int(31)
            static let medium = Int(33)
            static let large = Int(35)
            static let xlarge = Int(37)
            static let xxlarge = Int(39)
            static let xxxlarge = Int(41)
        }

//        Static.fontSizeTable = [
//            FioriUIFontTextStyle.kpiNumber.rawValue: [UIContentSizeCategory.extraSmall.rawValue: KPINumber1Size.xsmall, UIContentSizeCategory.small.rawValue: KPINumber1Size.small, UIContentSizeCategory.medium.rawValue: KPINumber1Size.medium, UIContentSizeCategory.large.rawValue: KPINumber1Size.large, UIContentSizeCategory.extraLarge.rawValue: KPINumber1Size.xlarge, UIContentSizeCategory.extraExtraLarge.rawValue: KPINumber1Size.xxlarge, UIContentSizeCategory.extraExtraExtraLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityMedium.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityExtraLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraLarge.rawValue: KPINumber1Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraExtraLarge.rawValue: KPINumber1Size.xxxlarge],
//
//            FioriUIFontTextStyle.kpiNumber2.rawValue: [UIContentSizeCategory.extraSmall.rawValue: KPINumber2Size.xsmall, UIContentSizeCategory.small.rawValue: KPINumber2Size.small, UIContentSizeCategory.medium.rawValue: KPINumber2Size.medium, UIContentSizeCategory.large.rawValue: KPINumber2Size.large, UIContentSizeCategory.extraLarge.rawValue: KPINumber2Size.xlarge, UIContentSizeCategory.extraExtraLarge.rawValue: KPINumber2Size.xxlarge, UIContentSizeCategory.extraExtraExtraLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityMedium.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityExtraLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraLarge.rawValue: KPINumber2Size.xxxlarge, UIContentSizeCategory.accessibilityExtraExtraExtraLarge.rawValue: KPINumber2Size.xxxlarge],
//        ]

//        Static.fontWeightTable = [
//            FioriUIFontTextStyle.kpiNumber.rawValue: "Thin",
//            FioriUIFontTextStyle.kpiNumber2.rawValue: "Light",
//        ]
//
//        Static.fontNameTable = [
//            FioriUIFontTextStyle.kpiNumber.rawValue: "SFUIDisplay",
//            FioriUIFontTextStyle.kpiNumber2.rawValue: "SFUIDisplay"
//        ]

        var contentSize = UIContentSizeCategory.large

        // This is a way to find out if UIApplication is initialized or not for framework unit testing
        // we could get EXC_BAD_ACCESS in calling UIApplication.shared().preferredContentSizeCategory when UIApplication object is not initialized yet
        if UIApplication.shared.description != "" {
            contentSize = UIApplication.shared.preferredContentSizeCategory
        }

        let style = Static.fontSizeTable[textStyle]!
        let fontName = "\(Static.fontNameTable[textStyle]!)-\(Static.fontWeightTable[textStyle]!)"

        return UIFontDescriptor(name: fontName, size: CGFloat(style[contentSize.rawValue]!))
    }
}
