import Foundation

// Need to use generics to conform to Codable, see link
// https://stackoverflow.com/questions/50346052/protocol-extending-encodable-or-codable-does-not-conform-to-it

// !!!!!! Keep everything internal for now, do not mark anything public !!!!!!

struct CAIMemoryOptions: Encodable {
    var merge: Bool
    var memory: AnyEncodable
}

protocol CAIAttachmentData: Encodable {
    var type: String { get }
    
    var text: String { get }
}

struct CAIMessageRequestData<T: CAIAttachmentData>: Encodable {
    var message: CAIMessageData<T>
    var memoryOptions: CAIMemoryOptions?
    
    var chatId: String
        
    init(_ content: T, _ conversationID: String, memoryOptions: MemoryOptions? = nil) {
        self.message = CAIMessageData(attachment: content)
        if let memoryOptionsNotNil = memoryOptions {
            self.memoryOptions = CAIMemoryOptions(merge: memoryOptionsNotNil.merge, memory: AnyEncodable(memoryOptionsNotNil.memory))
        }
        self.chatId = conversationID
    }
}

struct CAIMessageData<T: CAIAttachmentData>: Encodable {
    var attachment: T
}

struct CAITextAttachmentData: CAIAttachmentData {
    var text: String {
        self.content
    }
    
    var type = "text"
    
    var content: String
    
    init(_ text: String) {
        self.content = text
    }
}

struct CAIPostbackAttachmentData: CAIAttachmentData {
    var type: String
    
    private var content: CAIPostbackContent
    
    var text: String {
        self.content.title
    }
    
    init(_ type: PostbackType, _ buttonData: PostbackData) {
        self.type = type.rawValue
        self.content = CAIPostbackContent(with: buttonData)
    }
}

private struct CAIPostbackContent: Encodable {
    var type: String
    var title: String
    var value: String
    
    init(with buttonData: PostbackData) {
        self.type = buttonData.dataType.rawValue
        self.title = buttonData.title
        self.value = buttonData.value
    }
}
