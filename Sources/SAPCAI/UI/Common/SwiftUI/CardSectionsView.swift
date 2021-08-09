import SwiftUI

struct CardSectionsView: View {
    let section: ObjectSectionData
    @EnvironmentObject private var themeManager: ThemeManager
    private var attributesLen: Int {
        min(self.section.sectionAttributes != nil ? self.section.sectionAttributes!.count : 0, 5)
    }

    private var characterLimit: Int {
        25
    }

    var body: some View {
        ForEach(0 ..< attributesLen) { i in
            VStack(alignment: .leading, spacing: 0) {
                if self.section.sectionAttributes![i].value != nil &&
                    self.section.sectionAttributes![i].value!.count <= self.characterLimit
                {
                    CardSingleLineView(secAttribute: self.section.sectionAttributes![i])
                } else if self.section.sectionAttributes![i].value != nil &&
                    self.section.sectionAttributes![i].value!.count > self.characterLimit
                {
                    CardMultiLineView(secAttribute: self.section.sectionAttributes![i])
                }
                if i < self.attributesLen - 1 {
                    Divider().background(self.themeManager.color(for: .lineColor))
                        .padding([.leading], 16)
                }
            }
        }
    }
}

extension CardSectionsView {
    struct CardSingleLineView: View {
        let secAttribute: ValueData
        @EnvironmentObject private var viewModel: MessagingViewModel
        @EnvironmentObject private var themeManager: ThemeManager
        var body: some View {
            var urlVal = secAttribute.value!
            if secAttribute.type == .phoneNumber {
                urlVal = secAttribute.value!.toTelURLString()
            }
            if secAttribute.type == .email {
                urlVal = "mailto:" + secAttribute.value!
            }
            return HStack(alignment: .firstTextBaseline) {
                if secAttribute.label != nil {
                    Text(secAttribute.label!)
                        .font(.body)
                        .foregroundColor(self.themeManager.color(for: .primary1))
                        .lineLimit(1)
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 8))
                }
                Spacer()
                if secAttribute.value != nil {
                    if secAttribute.isClickable {
                        Button(action: {
                            self.viewModel.urlOpenerData.url = urlVal
                            URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: urlVal)
                        }, label: {
                            Text(secAttribute.value!)
                                .font(.body)
                                .lineLimit(1)
                                .padding([.top, .bottom], 10)
                                .padding([.trailing], 16)
                        })
                    } else {
                        Text(secAttribute.value!)
                            .font(.body)
                            .foregroundColor(self.themeManager.color(for: .primary1))
                            .lineLimit(1)
                            .padding([.top, .bottom], 10)
                            .padding([.trailing], 16)
                    }
                }
            }
        }
    }
    
    struct CardMultiLineView: View {
        let secAttribute: ValueData
        @EnvironmentObject private var viewModel: MessagingViewModel
        @EnvironmentObject private var themeManager: ThemeManager
        var body: some View {
            var urlVal = secAttribute.value!
            if secAttribute.type == .phoneNumber {
                urlVal = secAttribute.value!.toTelURLString()
            }
            if secAttribute.type == .email {
                urlVal = "mailto:" + secAttribute.value!
            }
            return VStack(alignment: .leading, spacing: 3) {
                if secAttribute.label != nil {
                    Text(secAttribute.label!)
                        .font(.subheadline)
                        .foregroundColor(self.themeManager.color(for: .primary2))
                        .lineLimit(1)
                        .padding([.top], 10)
                        .padding([.leading], 16)
                        .padding([.trailing], 16)
                }
                if secAttribute.value != nil {
                    if secAttribute.isClickable {
                        Button(action: {
                            self.viewModel.urlOpenerData.url = urlVal
                            URLNavigation(isUrlSheetPresented: self.$viewModel.urlOpenerData.isLinkModalPresented).performURLNavigation(value: urlVal)
                        }, label: {
                            Text(secAttribute.value!)
                                .font(.body)
                                .padding([.leading], 16)
                                .padding([.trailing], 16)
                                .padding([.bottom], 10)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        })
                    } else {
                        Text(secAttribute.value!)
                            .font(.body)
                            .foregroundColor(self.themeManager.color(for: .primary1))
                            .padding([.leading], 16)
                            .padding([.trailing], 16)
                            .padding([.bottom], 10)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

#if DEBUG
    struct CardSectionsView_Previews: PreviewProvider {
        static var previews: some View {
            CardSectionsView(section: PreviewData.cardSectionData)
                .environmentObject(ThemeManager.shared)
        }
    }
#endif
