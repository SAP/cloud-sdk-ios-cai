import Foundation
import SAPCAI
import SwiftUI

struct CustomMessage: MessageData {
    var isLastMessage: Bool = true
    
    var id: String
    
    var sender: SenderInfo
    
    var sentDate: Date
    
    var type: MessageType
    
    var buttons: [PostbackData]?
    
    init() {
        self.id = UUID().uuidString
        self.sender = User()
        self.sentDate = Date()
        self.buttons = [UIModelDataAction("Button 1", "Button 1", .text), UIModelDataAction("Button 2", "Button 2", .text)]
        self.type = .custom(CustomView("Hello custom view"))
    }
}

struct CustomView: AnyViewable {
    var view: AnyView {
        AnyView(Text(self.viewData as! String))
    }
    
    var viewData: Any?
    
    init(_ text: String) {
        self.viewData = text
    }
}

struct User: SenderInfo {
    var id: String { UUID().uuidString }
    
    var displayName: String { "User" }
    
    var isBot: Bool { false }
}
