import Foundation
import SwiftUI

/// A protocol used to represent the data for a message containing an URL (image or video).
public protocol MediaItem {
    /// The url where the media is located.
    var sourceUrl: URL? { get }

    /// The image.
//    var image: Image? { get }

    /// A placeholder image for when the image is obtained asynchronously.
    var placeholder: Image { get }

    /// The size of the media item.
    var size: CGSize { get }
}

/// Protocol describing the sections of a object card
public protocol ObjectSectionData {
    /// ID
    var id: String { get }

    /// title
    var title: String? { get }

    /// Attributes
    var sectionAttributes: [ValueData]? { get }
}

/// Protocol describing the content of an object card
public protocol ObjectMessageData {
    /// ID
    var id: String { get }

    /// Headline. Main text.
    var headline: String? { get }

    /// Subheadline. Secondary text.
    var subheadline: String? { get }

    /// Footnote. Tertiary text.
    var footnote: String? { get }

    /// Top right status.
    var status: ValueData? { get }

    /// Top right substatus.
    var substatus: String? { get }

    /// Specifies whether there is an image with this card
    var hasImage: Bool { get }

    /// URL of the image. Ignored if hasImage is false.
    var imageUrl: String? { get }

    /// List of actions for this card
    var objectButtons: [PostbackData]? { get }

    /// List of sections for this card
    var objectSections: [ObjectSectionData]? { get }
}

/// Protocol describing the header of a card
public protocol HeaderMessageData {
    /// Headline. Main text.
    var headline: String? { get }

    /// Subheadline. Secondary text.
    var subheadline: String? { get }

    /// Footnote. Tertiary text.
    var footnote: String? { get }

    /// Specifies whether there is an image with this header
    var hasImage: Bool { get }

    /// URL of the image. Ignored if hasImage is false.
    var imageUrl: String? { get }
    
    var status: ValueData? { get }
}

/// Protocol describing a list
public protocol ListMessageData {
    /// List Header
    var listHeader: HeaderMessageData? { get }

    /// List of items
    var items: [ObjectMessageData] { get }

    /// List Buttons
    var listButtons: [PostbackData]? { get }

    /// List Total
    var listTotal: Int? { get }

    /// List upper bound text
    var listUpperBoundText: String? { get }
}

/// Protocol describing a form
public protocol FormMessageData {
    /// Header
    var formHeader: HeaderMessageData? { get }

    // TODO: to be improved
    /// List of key-value pairs
    var fields: [String: String] { get }
}

/// Protocol describing a set of buttons
public protocol ButtonsMessageData {
    /// Text
    var buttonText: String? { get }

    /// List of actions
    var buttonsData: [PostbackData]? { get }
}

/// Protocol describing a carousel card
public protocol CarouselMessageData {
    /// List of items
    var carouselItems: [CarouselItemMessageData] { get }
}

/// Protocol describing the content of a carousel item
public protocol CarouselItemMessageData {
    /// ID
    var id: String { get }

    /// Picture
    var itemPicture: MediaItem? { get }

    /// Header
    var itemHeader: HeaderMessageData? { get }

    /// List of actions
    var itemButtons: [PostbackData]? { get }
    
    /// List of attributes
    var itemSections: [UIModelDataSection]? { get }
}
