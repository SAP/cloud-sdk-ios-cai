import Down
import Foundation
import SwiftUI

// MARK: - UIModelData format

/// Standard message format returns by CAI platform
/// Raw format parsed as-is from what the backend system returns
public struct UIModelData: Decodable {
    internal init(type: String, delay: TimeInterval? = nil, header: UIModelDataHeader? = nil, content: UIModelDataContent? = nil, detailsAvailable: Bool? = nil, buttons: [UIModelDataAction]? = nil, markdown: Bool? = nil) {
        self.type = type
        self.delay = delay
        self.header = header
        self.content = content
        self.detailsAvailable = detailsAvailable
        self.buttons = buttons
        self.markdown = markdown
    }

    var type: String = ""
    
    public var delay: TimeInterval?

    /// Header
    public var header: UIModelDataHeader?

    /// Content
    public var content: UIModelDataContent?

    /// Details are available or not
    public var detailsAvailable: Bool?

    /// Button
    public var buttons: [UIModelDataAction]?

    /// is format in Markdown
    public var markdown: Bool?

    private enum CodingKeys: String, CodingKey {
        case type
        case delay
        case header
        case content
        case detailsAvailable
        case buttons
        case markdown
    }

    public init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(String.self, forKey: .type)

        // handling the case that backend might return a number or a string for `delay`
        do {
            self.delay = try container.decodeIfPresent(TimeInterval.self, forKey: .delay)
        } catch DecodingError.typeMismatch {
            if let delayAsString = try container.decodeIfPresent(String.self, forKey: .delay) {
                self.delay = TimeInterval(delayAsString)
            }
        }

        self.header = try container.decodeIfPresent(UIModelDataHeader.self, forKey: .header)
        self.content = try container.decodeIfPresent(UIModelDataContent.self, forKey: .content)
        self.detailsAvailable = try container.decodeIfPresent(Bool.self, forKey: .detailsAvailable)
        self.buttons = try container.decodeIfPresent([UIModelDataAction].self, forKey: .buttons)

        // handling the case that backend might return a boolean or a string for `markdown`
        do {
            if let boolAsBool = try container.decodeIfPresent(Bool.self, forKey: .markdown) {
                self.markdown = boolAsBool
            }
        } catch DecodingError.typeMismatch {
            if let boolAsString = try container.decodeIfPresent(String.self, forKey: .markdown) {
                self.markdown = Bool(boolAsString)
            }
        }
    }
    
    /// Read-only convenient access to type property
    public var vizType: VisualizationType {
        VisualizationType(rawValue: self.type) ?? .unknown
    }

    /// URL to a media (video)
    /// title, subtile or description has to be of type LINK
    public var mediaUrl: String? {
        if header?.title?.isLink == true {
            return header?.title?.rawValue
        } else if header?.subtitle?.isLink == true {
            return header?.subtitle?.rawValue
        } else if header?.description?.isLink == true {
            return header?.description?.rawValue
        }
        return nil
    }
    
    mutating func processData() {
        if self.markdown == true, let markdownString = content?.text {
            let down = Down(markdownString: markdownString)
            do {
                let attr = try down.toAttributedString([.unsafe, .hardBreaks], styler: CAIStyler())
                self.content?.markdownText = attr
            } catch {}
        }
    }
    
    /// Value Type
    public enum ValueType: String {
        /// text
        case text
        /// link
        case link
        /// long text
        case longText = "longtext"
        /// phone number
        case phoneNumber = "phonenumber"
        /// email
        case email
    }
    
    /// Value State
    public enum ValueState: String {
        /// success
        case success
        /// error
        case error
        /// none
        case none
        /// information
        case info = "information"
        /// warning
        case warn = "warning"
    }
}

public struct UIModelDataHeader: Decodable {
    public var title: UIModelDataValue?
    public var subtitle: UIModelDataValue?
    public var description: UIModelDataValue?
    public var status1: UIModelDataValue?
    public var status2: UIModelDataValue?
    public var status3: UIModelDataValue?
    public var image: UIModelDataImage?
}

public struct UIModelDataSection: Decodable {
    public var title: String?
    public var attributes: [UIModelDataValue]?
    
    public init(_ title: String?, _ attributes: [UIModelDataValue]?) {
        self.title = title
        self.attributes = attributes
    }
}

public struct UIModelDataImage: Decodable {
    public var imageUrl: String
}

public struct UIModelDataValue: Decodable {
    /// (UI) value
    public var value: String?
    
    /**
     Provides semantic information about the content (helps renderer to know what to do)
     
     - SeeAlso: `UIModelData.ValueType`
     */
    public var dataType: String?
    
    /// Underlying value
    public var rawValue: String?
    
    /// only used in form
    public var label: String?
    
    /**
     Provides semantic information about the content (helps renderer to know what to do)
     
     - SeeAlso: `UIModelData.ValueState`
     */
    public var valueState: String?
    
    public var type: UIModelData.ValueType? {
        guard let typ = dataType else { return nil }
        return UIModelData.ValueType(rawValue: typ)
    }
    
    public var valState: UIModelData.ValueState {
        guard let val = valueState else { return .none }
        return UIModelData.ValueState(rawValue: val) ?? .none
    }
    
    public var isLink: Bool {
        self.type == .link
    }
    
    public init(value: String?, dataType: String?, rawValue: String?, label: String?, valueState: String?) {
        self.value = value
        self.dataType = dataType
        self.rawValue = rawValue
        self.label = label
        self.valueState = valueState
    }
}

/// Holds the content for a specific UIModelData. Properties will be filled based on UIModelData type.
public struct UIModelDataContent: Decodable {
    internal init(text: String? = nil, total: Int? = nil, upperBoundText: String? = nil, list: [UIModelDataContent]? = nil, form: [UIModelDataValue]? = nil, picture: UIModelDataMedia? = nil, video: UIModelDataMedia? = nil, header: UIModelDataHeader? = nil, buttons: [UIModelDataAction]? = nil, sections: [UIModelDataSection]? = nil, carousel: [UIModelDataContent]? = nil, markdownText: NSAttributedString? = nil) {
        self.text = text
        self.total = total
        self.upperBoundText = upperBoundText
        self.list = list
        self.form = form
        self.picture = picture
        self.video = video
        self.header = header
        self.buttons = buttons
        self.sections = sections
        self.carousel = carousel
        self.markdownText = markdownText
    }
    
    /// Required by ObjectMessageData. Generated GUID on client-side. Read-only.
    public let id = UUID().uuidString
    
    public var text: String?
    
    public var total: Int?
    
    public var upperBoundText: String?
    
    public var list: [UIModelDataContent]?
    
    public var form: [UIModelDataValue]?
    
    public var picture: UIModelDataMedia?
    
    public var video: UIModelDataMedia?
    
    public var header: UIModelDataHeader?

    public var buttons: [UIModelDataAction]?
    
    public var sections: [UIModelDataSection]?
    
    public var carousel: [UIModelDataContent]?
    
    /// removed elements where label/value are nil
    public var filteredForm: [UIModelDataValue]? {
        self.form?.filter { dv -> Bool in
            dv.value != nil || dv.label != nil
        }
    }
    
    /// :nodoc:
    /// Internal
    var markdownText: NSAttributedString?

    private enum CodingKeys: String, CodingKey {
        case text
        case total
        case upperBoundText
        case list
        case form
        case picture
        case video
        case header
        case buttons
        case sections
        case carousel
    }

    public init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decodeIfPresent(String.self, forKey: .text)

        // handling the case that backend might return a number (int/float) or a string for `total`
        do {
            if let totalAsInt = try container.decodeIfPresent(Int.self, forKey: .total) {
                self.total = totalAsInt
            }
        } catch DecodingError.typeMismatch {
            if let totalAsString = try container.decodeIfPresent(String.self, forKey: .total) {
                self.total = Int(totalAsString)
            }
        } catch DecodingError.dataCorrupted {
            if let totalAsFloat = try container.decodeIfPresent(Float.self, forKey: .total) {
                self.total = Int(totalAsFloat)
            }
        }

        self.upperBoundText = try container.decodeIfPresent(String.self, forKey: .upperBoundText)
        self.list = try container.decodeIfPresent([UIModelDataContent].self, forKey: .list)
        self.form = try container.decodeIfPresent([UIModelDataValue].self, forKey: .form)
        self.picture = try container.decodeIfPresent(UIModelDataMedia.self, forKey: .picture)
        self.video = try container.decodeIfPresent(UIModelDataMedia.self, forKey: .video)
        self.header = try container.decodeIfPresent(UIModelDataHeader.self, forKey: .header)
        self.buttons = try container.decodeIfPresent([UIModelDataAction].self, forKey: .buttons)
        self.sections = try container.decodeIfPresent([UIModelDataSection].self, forKey: .sections)
        self.carousel = try container.decodeIfPresent([UIModelDataContent].self, forKey: .carousel)
    }
}

public struct UIModelDataAction: Decodable {
    public var title: String
    
    public var value: String
    
    public var type: String
    
    public init(_ title: String, _ value: String, _ type: PostbackDataType) {
        self.title = title
        self.value = value
        self.type = type.rawValue
    }
}

/// Used for Image & Video cards
public struct UIModelDataMedia: Decodable {
    /// URL to the image or video
    public var url: String?
    
    public var width: String?
    
    public var height: String?
    
    public var iWidth: Int {
        self.width != nil ? Int(self.width!) ?? 400 : 400
    }

    public var iHeight: Int {
        self.height != nil ? Int(self.height!) ?? 300 : 300
    }

    public var type: String?
    
    public var mediaType: MediaType? {
        guard let t = type else { return nil }
        return MediaType(rawValue: t)
    }
    
    /// Media Type
    public enum MediaType: String {
        case link = "LINK"
        case avatar = "AVATAR"
    }
    
    public init(url: String) {
        self.url = url
    }

    public init(url: String, width: Int, height: Int) {
        self.url = url
        self.width = String(width)
        self.height = String(height)
    }
}

/// Available Visualization type of CAI cards
public enum VisualizationType: String, CaseIterable {
    /// Text card
    case text
    case TEXT
    
    /// Single object card
    case object
    
    /// Form card
    case form
    
    /// List card
    case list
    
    /// Video card
    case video
    
    /// Picture card
    case picture
    
    /// Quick Replies
    case quickReplies
    
    /// Buttons
    case buttons
    
    /// Carousel
    case carousel
    
    /// Unknown
    case unknown
}

// MARK: - Extensions for UI Message Data protocols

extension UIModelDataAction: PostbackData {
    public var id: String {
        String("\(self.title)-\(self.value)-\(self.type)".hashValue)
    }
    
    public var dataType: PostbackDataType {
        PostbackDataType(rawValue: self.type) ?? .postback
    }
}

extension UIModelDataValue: ValueData {
    public var id: String {
        UUID().uuidString
    }
}

extension UIModelDataSection: ObjectSectionData {
    public var id: String {
        UUID().uuidString
    }
    
    public var sectionAttributes: [ValueData]? {
        self.attributes
    }
}

extension UIModelDataContent: ObjectMessageData {
    public var headline: String? {
        self.header?.title?.value
    }
    
    public var subheadline: String? {
        self.header?.subtitle?.value
    }
    
    public var footnote: String? {
        self.header?.description?.value
    }
    
    public var status: ValueData? {
        self.header?.status1
    }
    
    public var substatus: String? {
        self.header?.status2?.value
    }
    
    public var hasImage: Bool {
        self.header?.image != nil
    }
    
    public var imageUrl: String? {
        self.header?.image?.imageUrl
    }
    
    public var objectSections: [ObjectSectionData]? {
        self.sections
    }
    
    public var objectButtons: [PostbackData]? {
        self.buttons
    }
}

extension UIModelDataContent: CarouselItemMessageData {
    public var itemPicture: MediaItem? {
        self.picture
    }
    
    public var itemHeader: HeaderMessageData? {
        self.header
    }
    
    public var itemButtons: [PostbackData]? {
        self.buttons
    }
}

extension UIModelDataHeader: HeaderMessageData {
    public var headline: String? {
        self.title?.value
    }
    
    public var subheadline: String? {
        self.subtitle?.value
    }
    
    public var footnote: String? {
        self.description?.value
    }
    
    public var hasImage: Bool {
        self.image != nil
    }
    
    public var imageUrl: String? {
        self.image?.imageUrl
    }
}

extension UIModelData: ListMessageData {
    public var listHeader: HeaderMessageData? {
        self.content?.header
    }
    
    public var items: [ObjectMessageData] {
        self.content?.list ?? []
    }
    
    public var listButtons: [PostbackData]? {
        self.content?.buttons
    }
    
    public var listTotal: Int? {
        self.content?.total
    }
    
    public var listUpperBoundText: String? {
        self.content?.upperBoundText
    }
}

extension UIModelData: FormMessageData {
    public var formHeader: HeaderMessageData? {
        self.header
    }
    
    public var fields: [String: String] {
        guard let form = content?.form else {
            return [:]
        }
        let dict = Dictionary(uniqueKeysWithValues: form.map { ($0.label!, $0.value!) })
        
        return dict
    }
}

extension UIModelData: ButtonsMessageData {
    public var buttonText: String? {
        self.content?.text
    }
    
    public var buttonsData: [PostbackData]? {
        self.content?.buttons
    }
}

extension UIModelData: CarouselMessageData {
    public var carouselItems: [CarouselItemMessageData] {
        self.content?.carousel ?? []
    }
}

extension UIModelDataMedia: MediaItem {
    public var sourceUrl: URL? {
        if let sURL = url {
            return URL(string: sURL)
        }
        return nil
    }
    
    public var placeholder: SwiftUI.Image {
        Image(systemName: "person.crop.circle")
    }
    
    public var size: CGSize {
        CGSize(width: CGFloat(self.iWidth), height: CGFloat(self.iHeight))
    }
}
