// swiftlint:disable all
#if DEBUG
    import Foundation

    struct PreviewData {
        /// for ObjectMessageView
        static var objectMessage: [ObjectMessageData] {
            var arr = [ObjectMessageData]()
            let header = UIModelDataHeader(title: UIModelDataValue(value: "Image testing title with approx",
                                                                   dataType: "text",
                                                                   rawValue: nil,
                                                                   label: nil,
                                                                   valueState: nil),
                                           subtitle: UIModelDataValue(value: "List subtitle 1",
                                                                      dataType: "text",
                                                                      rawValue: nil,
                                                                      label: nil,
                                                                      valueState: nil),
                                           image: UIModelDataImage(imageUrl: "sap-icon://desktop-mobile"))
        
            let longSubtitleheader = UIModelDataHeader(title: UIModelDataValue(value: "Image testing title with approx",
                                                                               dataType: "text",
                                                                               rawValue: nil,
                                                                               label: nil,
                                                                               valueState: nil),
                                                       subtitle: UIModelDataValue(value: "Long description: Apple for years has focused on adding ne",
                                                                                  dataType: "text",
                                                                                  rawValue: nil,
                                                                                  label: nil,
                                                                                  valueState: nil),
                                                       image: UIModelDataImage(imageUrl: "sap-icon://desktop-mobile"))
            let shotButtonMessage = UIModelDataContent(header: header,
                                                       buttons: [UIModelDataAction("Link", "https://www.link.com", .link)])
            let longButtonMessage = UIModelDataContent(header: header,
                                                       buttons: [UIModelDataAction("Long Button AABBCC DD", "https://www.link.com", .link)])
            let longSubtitleButtonMessage = UIModelDataContent(header: longSubtitleheader,
                                                               buttons: [UIModelDataAction("Long Button AABBCC DD", "https://www.link.com", .link)])
            arr.append(contentsOf: [shotButtonMessage, longButtonMessage, longSubtitleButtonMessage])
            return arr
        }
    
        /// for QuickRepliesMessageView
        static var quickReply: MessagingViewModel {
            let viewModel = MessagingViewModel(publisher: MockPublisher())
            let text = "Apple for years has focused on adding new programs to its phones, all designed to make life"
            let iButtons = [UIModelDataAction("QC1", "QC1", .text),
                            UIModelDataAction("QC2", "QC2", .text),
                            UIModelDataAction("QC3", "QC3", .text),
                            UIModelDataAction("QC4withexac19char", "QC4withexac19char", .text),
                            UIModelDataAction("QC5withexac20chars", "QC5withexac20chars", .text),
                            UIModelDataAction("QC6withexac21chars1", "QC6withexac21chars1", .text),
                            UIModelDataAction("QC7withexac22chars12", "QC7withexac22chars12", .text),
                            UIModelDataAction("QC8", "QC8", .text),
                            UIModelDataAction("QC9", "QC9", .text),
                            UIModelDataAction("QC10", "QC10", .text),
                            UIModelDataAction("QC11", "QC11", .text)]
            let responseData = CAIResponseMessageData(text: text, iButtons, buttonType: .quickReplies)
            viewModel.addMessages(contentsOf: [responseData])
            return viewModel
        }

        static var cardSectionData: UIModelDataSection {
            func makeDataValue(label: String? = nil, value: String? = nil, dataType: String? = nil) -> UIModelDataValue {
                UIModelDataValue(value: value, dataType: dataType, rawValue: nil, label: label, valueState: nil)
            }
            return UIModelDataSection("title", [makeDataValue(label: "text",
                                                              value: "Just text",
                                                              dataType: "text"),
                                                makeDataValue(label: "link address",
                                                              value: "https://www.sap.com",
                                                              dataType: "link"),
                                                makeDataValue(label: "email address",
                                                              value: "example@sap.com",
                                                              dataType: "email"),
                                                makeDataValue(label: "tel",
                                                              value: "+1 23 388913 23 ",
                                                              dataType: "phonenumber"),
                                                makeDataValue(label: "real address",
                                                              value: "1234, CA, USA",
                                                              dataType: "address")])
        }

        /// carousel item data
        static var carouselMessageData: MessageData {
            let iButtons = [
                UIModelDataAction("See more", "See more", .text),
                UIModelDataAction("See more again", "See more again", .text)
            ]
            let iAttributes = [UIModelDataValue(value: "This is item 1", dataType: "text", rawValue: nil, label: "Item 1", valueState: nil),
                               UIModelDataValue(value: "This is item 2", dataType: "text", rawValue: nil, label: "Item 2", valueState: nil),
                               UIModelDataValue(value: "https://www.sap.com", dataType: "link", rawValue: nil, label: "Link 1", valueState: nil),
                               UIModelDataValue(value: "https://www.youtube.com", dataType: "link", rawValue: nil, label: "Link 2", valueState: nil),
                               UIModelDataValue(value: "+1-408-999-9999", dataType: "phonenumber", rawValue: nil, label: "Phone", valueState: nil),
                               UIModelDataValue(value: "john.smith@sap.com", dataType: "email", rawValue: nil, label: "Email", valueState: nil),
                               UIModelDataValue(value: "this is a long text. this is a long text. this is a long text. ", dataType: "text", rawValue: nil, label: "label for long text", valueState: nil),
                               UIModelDataValue(value: "great job!", dataType: "text", rawValue: nil, label: "short label", valueState: nil)]

            let iSections = [UIModelDataSection("Section1", iAttributes)]

            let data = CAIResponseMessageData(title: "Dog", subtitle: "Without the cutiest animal on the planet, am I right?", featuredImageName: "https://thelabradorclub.com/wp-content/uploads/2016/09/purpose-bg.jpg", inlineButtons: iButtons, sections: iSections, isBot: true)
            let viewModel = MessagingViewModel(publisher: MockPublisher())
            viewModel.addMessage(CAIResponseMessageData([data.attachment.content!], true))
            return viewModel.model[0]
        }

        static var carouselDetail: CarouselItemMessageData? {
            if case .carousel(let data) = carouselMessageData.type {
                return data.carouselItems[0]
            }
            return nil
        }

        static var cardWithoutImage: CardMessageData? {
            let cardMessageData = CAIResponseMessageData(title: "Laptop Lenovo",
                                                         subtitle: "Card image as sap-icon",
                                                         headerImageName: "sap-icon://order-status",
                                                         status1: "Available")
            if case .object(let data) = cardMessageData.type {
                return data
            }
            return nil
        }

        static func card(title: Bool, subtitle: Bool, image: PreviewImage?, status: Bool) -> CardMessageData? {
            let titleText: String = title ? "Title" : ""
            let subtitleText: String = title ? "Sub" : ""
            let statusText: String = title ? "Available" : ""
            var cardMessageData: CAIResponseMessageData!
            var imageAddress: String = ""
            if let image = image {
                switch image.type {
                case .icon:
                    imageAddress = "sap-icon://order-status"
                case .regular:
                    imageAddress = "https://thelabradorclub.com/wp-content/uploads/2016/09/purpose-bg.jpg"
                }

                switch image.placement {
                case .header:
                    cardMessageData = CAIResponseMessageData(title: titleText,
                                                             subtitle: subtitleText,
                                                             headerImageName: imageAddress,
                                                             status1: statusText)
                case .content:
                    cardMessageData = CAIResponseMessageData(title: titleText,
                                                             subtitle: subtitleText,
                                                             featuredImageName: imageAddress,
                                                             inlineButtons: [],
                                                             status1: statusText)
                }
            } else {
                cardMessageData = CAIResponseMessageData(title: titleText,
                                                         subtitle: subtitleText,
                                                         status1: statusText)
            }

            if case .object(let data) = cardMessageData.type {
                return data as! CarouselItemMessageData
            }
            return nil
        }
    }

    struct PreviewImage {
        var type: CardImageType
        var placement: CardImagePlacement
    }

    enum CardImagePlacement {
        case header
        case content
    }

    enum CardImageType {
        case icon
        case regular
    }

#endif
// swiftlint:enable all
