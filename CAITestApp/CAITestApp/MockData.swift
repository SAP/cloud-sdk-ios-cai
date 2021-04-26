import Foundation
import SAPCAI

struct MockData {
    static let viewModel: MessagingViewModel = {
        let vm = MessagingViewModel(publisher: MockPublisher())
        
        // message list
        var arr = [MessageData]()
        
        // text message 1 (user)
        arr.append(CAIResponseMessageData(text: "Hi", false))

        // text message 1.5 (bot)
        arr.append(CAIResponseMessageData(text: "Hello, what can I do for you today?", true))

        // text message 2 (user)
        arr.append(CAIResponseMessageData(text: "My own long message to analize where text wraps and make sure the container is rendered correctly", false))
        
        // text message 3 (bot)
        arr.append(CAIResponseMessageData(text: "My own long message to analize where text wraps and make sure it works", true))

        // text with quick replies 4
        var m = CAIResponseMessageData(text: "Text with quick reply buttons", [
            UIModelDataAction("Text Button", "Button1", .text),
            UIModelDataAction("Link Universal", "https://www.youtube.com/watch?v=RXsIah6HvgU", .link),
            UIModelDataAction("Link URLScheme", "comgooglemaps://?q=Steamers+Lane+Santa+Cruz,+CA&center=37.782652,-122.410126&views=satellite,traffic&zoom=15", .link)
        ], buttonType: .quickReplies)
        arr.append(m)
        
        // text message 5 (user)
        arr.append(CAIResponseMessageData(text: "Yet another question to my bot", false))
        
        // markdown text message 6
        arr.append(CAIResponseMessageData(text: "**Here is some bold**", true, markdown: true))
        
        // markdown text message 7
        arr.append(CAIResponseMessageData(text: "**Here is some text in bold** and also some regular text", true, markdown: true))
        
        // markdown text message 8
        arr.append(CAIResponseMessageData(text: "# Heading1 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true))
        // markdown text message 9
        arr.append(CAIResponseMessageData(text: "## Heading2 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true))
        // markdown text message 10
        arr.append(CAIResponseMessageData(text: "### Heading3 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true))
        // markdown text message 11
        arr.append(CAIResponseMessageData(text: "#### Heading4 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true))
        // markdown text message 12
        arr.append(CAIResponseMessageData(text: "##### Heading5 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true))
        // markdown text message 13
        arr.append(CAIResponseMessageData(text: "###### Heading6 head\n**Here is some text in bold** and also some regular text and also a link to [google](https://www.google.com) with *italic text*", true, markdown: true))
    
        // text message 9 (user)
        arr.append(CAIResponseMessageData(text: "Show me products", false))
        
        // card 9.1
        var iButtons = [UIModelDataAction("Order", "Order", .text), UIModelDataAction("Universal", "https://www.youtube.com/watch?v=RXsIah6HvgU", .link)]
        var hp1 = CAIResponseMessageData("Laptop Lenovo",
                                         "This is a great Laptop", "https://cdn.cnetcontent.com/d7/8d/d78d88da-e0a1-4607-abc5-991c92223a39.jpg",
                                         nil,
                                         iButtons,
                                         nil,
                                         "Available")
        arr.append(hp1)
        
        // card 9.2
        iButtons = [UIModelDataAction("Order2", "Order2", .text)]
        var hp2 = CAIResponseMessageData("Laptop Lenovo",
                                         "This is a great Laptop",
                                         "sap-icon://order-status",
                                         nil,
                                         iButtons,
                                         nil,
                                         "Available")
        arr.append(hp2)
        
        // card 9.3
        iButtons = [UIModelDataAction("Order3", "Order3", .text)]
        
        var iAttributes = [UIModelDataValue(value: "This is item 1", dataType: "text", rawValue: nil, label: "Item 1", valueState: nil),
                           UIModelDataValue(value: "This is item 2", dataType: "text", rawValue: nil, label: "Item 2", valueState: nil),
                           UIModelDataValue(value: "https://www.sap.com", dataType: "link", rawValue: nil, label: "Link1", valueState: nil),
                           UIModelDataValue(value: "https://www.youtube.com", dataType: "link", rawValue: nil, label: "Link2", valueState: nil),
                           UIModelDataValue(value: "+1-408-464-3537", dataType: "phonenumber", rawValue: nil, label: "Phone1", valueState: nil),
                           UIModelDataValue(value: "john.smith@acme.com", dataType: "email", rawValue: nil, label: "Email1", valueState: nil)]
        var iSections = [UIModelDataSection("Section1", iAttributes)]
        var hp3 = CAIResponseMessageData("Laptop Lenovo2",
                                         "This is a great Laptop2",
                                         "sap-icon://order-status",
                                         nil,
                                         iButtons,
                                         iSections,
                                         "Not Available")
        arr.append(hp3)
        
        // card 9.4
        iButtons = [UIModelDataAction("This is very big button", "This is very big button", .text)]
        
        iAttributes = [UIModelDataValue(value: "This is very long item very long item very long item very long item very long item very long item", dataType: "text", rawValue: nil, label: "Item 1", valueState: nil),
                       UIModelDataValue(value: "This is item 2", dataType: "text", rawValue: nil, label: "Item 2", valueState: nil),
                       UIModelDataValue(value: "https://www.hackingwithswift.com/forums/100-days-of-swiftui/how-do-i-restrict-textview-input-to-a-certain-number-of-characters/763", dataType: "link", rawValue: nil, label: "This is a very long Link1", valueState: nil),
                       UIModelDataValue(value: "superlongfirstnamesuperlongfirstnamesuperlongfirstname.superlonglastnamesuperlonglastnamesuperlonglastname@sap.com", dataType: "email", rawValue: nil, label: "Email1", valueState: nil)]
        iSections = [UIModelDataSection("Section1", iAttributes)]
        var hp4 = CAIResponseMessageData("Laptop Lenovo2",
                                         "This is a great Laptop2",
                                         "sap-icon://order-status",
                                         nil,
                                         iButtons,
                                         iSections,
                                         "Not Available")
        arr.append(hp4)
        
        // text message 10 (user)
        arr.append(CAIResponseMessageData(text: "Do you have a list of buttons?", false))

        // text with buttons message 11
        iButtons = [
            UIModelDataAction("button type b1", "b1", .text),
            UIModelDataAction("button type b2", "b2", .text),
            UIModelDataAction("button type b3", "b3", .text),
            UIModelDataAction("button type b4", "b4", .text),
            UIModelDataAction("button type b5", "b5", .text),
            UIModelDataAction("button type b6", "b6", .text),
            UIModelDataAction("button type b7", "b7", .text),
            UIModelDataAction("button type b8", "b8", .text),
            UIModelDataAction("button type b9", "b9", .text),
            UIModelDataAction("button type b10", "b10", .text),
            UIModelDataAction("button type b11", "b11", .text),
            UIModelDataAction("button type b12", "b12", .text),
            UIModelDataAction("button type b13", "b13", .text),
            UIModelDataAction("button type b14", "b14", .text),
            UIModelDataAction("button type b15", "b15", .text),
            UIModelDataAction("button type b16 hidden", "b16", .text)
        ]
        m = CAIResponseMessageData(text: "This is buttons", iButtons, buttonType: .buttons)
        arr.append(m)
        
        // text with buttons message 11.1
        iButtons = [
            UIModelDataAction("button type b1", "b1", .text),
            UIModelDataAction("button type b2", "b2", .text),
            UIModelDataAction("button type b3", "b3", .text)
        ]
        m = CAIResponseMessageData(text: "This is buttons", iButtons, buttonType: .buttons)
        arr.append(m)
        
        // text message 12
        arr.append(CAIResponseMessageData(text: "Any quick replies?", false))
        
        // text with quick replies 13
        iButtons = [
            UIModelDataAction("qr type b1", "Reply b1", .text),
            UIModelDataAction("qr type b2", "Reply b2", .text),
            UIModelDataAction("qr type b3", "Reply b3", .text),
            UIModelDataAction("qr type b11", "Reply b11", .text),
            UIModelDataAction("qr type b22", "Reply b22", .text),
            UIModelDataAction("qr type b33", "Reply b33", .text),
            UIModelDataAction("qr type b111", "Reply b111", .text),
            UIModelDataAction("qr type b222", "Reply b222", .text),
            UIModelDataAction("qr type b333", "Reply b333", .text)
        ]
        m = CAIResponseMessageData(text: "This is Quick Replies", iButtons, buttonType: .quickReplies)
        arr.append(m)
        
        // text message 16 (user)
        arr.append(CAIResponseMessageData(text: "Please show me a picture of a Mustang on a race track and some hops", false))
        
        // image 17
        arr.append(CAIResponseMessageData(imageName: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/2019-mustang-shelby-gt350-101-1528733363.jpg?crop=0.817xw:1.00xh;0.149xw,0&resize=640:*"))
        
        // image 17.2
        arr.append(CAIResponseMessageData(imageName: "https://pbs.twimg.com/profile_images/3740869426/dfbd05510a00d82ba3acd1d5b9049c43.png"))
        
        // text message 18 (user)
        arr.append(CAIResponseMessageData(text: "Thank you", false))
        
        // text message 19 (bot)
        arr.append(CAIResponseMessageData(text: "Long message to analize where text wraps and make sure the container is rendered correctly"))
        
        // error image 20
        // arr.append(CAIResponseMessageData(imageName: nil))
        
        // text message 21 (user)
        arr.append(CAIResponseMessageData(text: "I want to watch a video", false))
        
        // video 21.5
        arr.append(CAIResponseMessageData(videoUrl: "https://www.youtube.com/watch?v=tOlYWKifhUI"))
    
        // text message 22 (user)
        arr.append(CAIResponseMessageData(text: "List products", false))

        // list 23
        var headerArr = [CAIResponseMessageData]()
        iButtons = [
            UIModelDataAction("b1", "b1", .text)
        ]
        var h1 = CAIResponseMessageData("HP Laptop", "HP Laptop - 15 inch touch screen with Intel i7 processor.", "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962448.png", nil, iButtons, nil, "Available", nil, nil, true)
        
        headerArr.append(h1)
    
        iButtons = [
            UIModelDataAction("List postback", "List postback", .postback)
        ]
        var h2 = CAIResponseMessageData("iPhone XR", "iPhone", "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xr/iphone-xr-black-select-201809?wid=470&hei=556&fmt=png-alpha&.v=1551226038992", nil, iButtons, nil, "Out of Stock", nil, nil, true)
        h2.attachment.buttons = iButtons
        headerArr.append(h2)
        
        var h3 = CAIResponseMessageData("Samsung Galaxy s10", "samsung galaxy", nil, nil, nil, nil, "Available", "In Stock", nil, true)
        headerArr.append(h3)
    
        iButtons = [
            UIModelDataAction("Link1", "https://www.google.com", .link),
            UIModelDataAction("Link2", "https://www.pinterest.com", .link),
            UIModelDataAction("Phone1", "14081231234", .phoneNumber),
            UIModelDataAction("Phone2", "14081231235", .phoneNumber),
            UIModelDataAction("Phone3", "14081231235", .phoneNumber)
        ]
        var h4 = CAIResponseMessageData("Product4", "Product 4", "https://freeicons.io/laravel/public/uploads/icons/png/12835256891551942291-128.png", nil, iButtons, nil, "Available", nil, nil, true)
        headerArr.append(h4)
        
        iButtons = [
            UIModelDataAction("List icon very large text", "List icon very large text", .text)
        ]
        var h5 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h5.attachment.buttons = iButtons
        headerArr.append(h5)
        
        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h6 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h6.attachment.buttons = iButtons
        headerArr.append(h6)
        
        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h7 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h7.attachment.buttons = iButtons
        headerArr.append(h7)
        
        iButtons = [
            UIModelDataAction("List icon", "List icon", .text)
        ]
        var h8 = CAIResponseMessageData("iPhone", "iPhone", "sap-icon://desktop-mobile", nil, iButtons, nil, nil, nil, nil, true)
        h8.attachment.buttons = iButtons
        headerArr.append(h8)
    
        iButtons = [
            UIModelDataAction("Footer button", "Footer button", .text)
        ]
        arr.append(CAIResponseMessageData(headerArr.map { $0.attachment.content! }, iButtons, "List of Products", "Electronics", "Sample Electronics", false))
        
        // text message 24 (user)
        arr.append(CAIResponseMessageData(text: "I am wondering and thinking about something, if a long message to analize where text wraps and make sure the container is rendered correctly", false))

        // card 25
        var card25 = CAIResponseMessageData("Laptop Lenovo", "This is a great Laptop", "https://cdn.cnetcontent.com/d7/8d/d78d88da-e0a1-4607-abc5-991c92223a39.jpg", nil, nil, nil, "Available", "$1,200")
        arr.append(card25)

        arr.append(CAIResponseMessageData(text: "I like to play with carousels", false))
        var carouselArr = [CAIResponseMessageData]()
        iButtons = [
            UIModelDataAction("carousel b1", "carousel b1", .text)
        ]
        var c1 = CAIResponseMessageData("Test1", "Test1 desc", "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/2019-mustang-shelby-gt350-101-1528733363.jpg?crop=0.817xw:1.00xh;0.149xw,0&resize=640:*", nil, iButtons, nil, nil, nil, nil, true)
            
        carouselArr.append(c1)
        iButtons = [
            UIModelDataAction("carousel button button button button 2", "carousel button button button button 2 ", .text)
        ]
        var c2 = CAIResponseMessageData("Test2", "Test2 desc Test2 desc Test2 desc desc desc desc", "https://thelabradorclub.com/wp-content/uploads/2016/09/purpose-bg.jpg", nil, iButtons, nil, nil, nil, nil, true)
        
        carouselArr.append(c2)
        
        var c3 = CAIResponseMessageData("Test3", "Test3 desc desc desc desc desc", nil, nil, iButtons, nil, nil, nil, nil, true)
        
        carouselArr.append(c3)
        
        var c4 = CAIResponseMessageData("Test4", "Test4 desc Test4 desc Test4 desc Test4 desc really long desc", nil, nil, iButtons, nil, nil, nil, nil, true)
        
        carouselArr.append(c4)
        
        arr.append(CAIResponseMessageData(carouselArr.map { $0.attachment.content! }, true))
        
        // images
        arr.append(CAIResponseMessageData(imageName: "https://dummyimage.com/700x25/000/fff"))
        arr.append(CAIResponseMessageData(imageName: "https://dummyimage.com/39x10/000/fff"))
        arr.append(CAIResponseMessageData(imageName: "https://dummyimage.com/12x32/000/fff"))
        arr.append(CAIResponseMessageData(imageName: "https://dummyimage.com/30x860/000/fff"))
        arr.append(CAIResponseMessageData(imageName: "https://dummyimage.com/600x200/000/fff"))
        arr.append(CAIResponseMessageData(imageName: "https://dummyimage.com/600x500/000/fff"))

        // KEEP THIS ONE LAST
        
        // text message 14 (user)
        arr.append(CAIResponseMessageData(text: "Can you render custom content?", false))
        
        // custom cell message 15
        let cell = CustomMessage()
        arr.append(cell)

        vm.addMessages(contentsOf: arr)
        
        // preferences menu
        var menuAction1 = CAIChannelMenuDataAction("Google", "Link", "https://www.google.com", nil)
        var menuAction2 = CAIChannelMenuDataAction("Postback1", "postback", "This is postback1", nil)
        var menuAction4 = CAIChannelMenuDataAction("SAP", "Link", "https://www.sap.com", nil)
        var menuAction5 = CAIChannelMenuDataAction("Postback2", "postback", "This is postback2", nil)
        
        var menuAction3_1 = CAIChannelMenuDataAction("Youtube", "Link", "https://www.youtube.com", nil)
        var menuAction3_2 = CAIChannelMenuDataAction("Postback2", "postback", "This is postback2", nil)
        var menuAction3_4 = CAIChannelMenuDataAction("Youtube2", "Link", "https://www.youtube.com", nil)
        var menuAction3_5 = CAIChannelMenuDataAction("Postback3", "postback", "This is postback3", nil)
        
        var menuAction3_3_1 = CAIChannelMenuDataAction("Youtube2", "Link", "https://www.youtube.com", nil)
        var menuAction3_3_2 = CAIChannelMenuDataAction("Postback3", "postback", "This is postback3", nil)
        var menuAction3_3_3 = CAIChannelMenuDataAction("Youtube4", "Link", "https://www.youtube.com", nil)
        var menuAction3_3_4 = CAIChannelMenuDataAction("Postback5", "postback", "This is postback5", nil)
        var nestedActions2 = [CAIChannelMenuDataAction]()
        nestedActions2.append(menuAction3_3_2)
        nestedActions2.append(menuAction3_3_1)
        nestedActions2.append(menuAction3_3_4)
        nestedActions2.append(menuAction3_3_3)

        var menuAction3_3 = CAIChannelMenuDataAction("Nested2", "nested", nil, nestedActions2)
        
        var nestedActions = [CAIChannelMenuDataAction]()
        nestedActions.append(menuAction3_3)
        nestedActions.append(menuAction3_1)
        nestedActions.append(menuAction3_2)
        nestedActions.append(menuAction3_5)
        nestedActions.append(menuAction3_4)

        var menuAction3 = CAIChannelMenuDataAction("Nested1", "nested", nil, nestedActions)
        
        var menuActions = [CAIChannelMenuDataAction]()
        menuActions.append(menuAction2)
        menuActions.append(menuAction3)
        menuActions.append(menuAction1)
        menuActions.append(menuAction5)
        menuActions.append(menuAction4)

        var md = CAIChannelMenuData("en", menuActions)
        var pm = CAIChannelPreferencesMenuData("en", md)
        
        vm.menu = pm
        return vm
    }()
}
