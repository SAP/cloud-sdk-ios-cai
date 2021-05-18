
# cloud-sdk-ios-cai 

<p align="center">
  <img width=20% src="https://www.sap.com/content/dam/application/imagelibrary/pictograms/283000/283370-pictogram-purple.svg" alt="Logo" />
  </br>
  <span><b>SAP Conversational AI SDK for iOS</b></span>
</p>

***

<div align="center">
    <a href="https://github.com/SAP/cloud-sdk-ios-cai/actions?query=workflow%3A%22CI%22">
        <img src="https://github.com/SAP/cloud-sdk-ios-cai/workflows/CI/badge.svg"
             alt="Build Status">
    </a>
    <a href="https://api.reuse.software/info/github.com/SAP/cloud-sdk-ios-cai">
        <img src="https://api.reuse.software/badge/github.com/SAP/cloud-sdk-ios-cai"
             alt="REUSE status">
    </a>
    <a href="http://commitizen.github.io/cz-cli/">
        <img src="https://img.shields.io/badge/commitizen-friendly-brightgreen.svg"
             alt="Commitizen friendly">
    </a>
    <a href="https://conventionalcommits.org">
        <img src="https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg"
             alt="Conventional Commits">
    </a>
</div>

***

The `SAPCAI` Swift Package is a module to connect to a bot on the end-to-end chatbot platform [SAP Conversation AI](https://www.sap.com/products/conversational-ai.html) (CAI) and to provide a pluggable SwiftUI `AssistantView` to initiate a conversation and render the various [message types](https://help.sap.com/viewer/a4522a393d2b4643812b7caadfe90c18/latest/en-US/ad3681adae824f8a96cbcf8b889a4ffc.html).

## Installation

The package is intended for consumption via Swift Package Manager. To add `SAPCAI` to your application target, navigate to the  <kbd>File </kbd> >  <kbd>Swift Packages </kbd> >  <kbd>Add Package Dependency... </kbd>, then add the repository URL https://github.com/SAP/cloud-sdk-ios-cai.

## Requirements

- iOS 13 or higher
- Xcode 12 (Swift 5.3) or higher
  
## Prerequisites

- You have existing bot(s) on the SAP Conversational AI platform (either Enterprise or Community edition)
- Your bot(s) are connected to a mobile channel

As long as mobile channel activation is not possible in the SAP Conversational AI you can perform this one-time activity via the [/channel](https://reverseproxy.cai.tools.sap/docs/api-reference/#channels) API.
 
```bash
# create a mobile channel
curl -X POST "<BaseUrl>/connect/v1/channels" \
-H "X-Token: Token <DeveloperToken>" \
-H "Content-Type: application/json" \
-d '{"type":"mobile","slug":"<desiredChannelSlug>","connectionTarget": "SAP_Product","targetSystem": "MobileBot","isActivated":true}'
```

## Dependencies

- [SAPCommon](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/Latest/en-US/Documents/Frameworks/SAPCommon/index.html) for Logging
- [SAPFoundation](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/Latest/en-US/Documents/Frameworks/SAPFoundation/index.html) for Network Connectivity and Authentication
- [URLImage](https://github.com/dmytro-anokhin/url-image) for asynchronous image loading in SwiftUI
- [Down](https://github.com/johnxnguyen/Down) for Markdown / CommonMark rendering in Swift

## Getting Started

The code snippet below illustrates how to set up the `CAIConversation` Combine publisher in order to initialize the `MessagingViewModel` for the `AssistantView`.

### Setting up the data publisher

```Swift
import SAPCAI
import SAPFoundation
import SwiftUI

// create the CAIChannel object by providing the channel id, channel token and channel slug that was created in CAI Platform.
let caiChannel = CAIChannel(id: "<channelId>", token: "<channelToken>", slug: "<channelSlug>").
        
let polling: MessageDelivering

let session = SAPURLSession()

// example-specific extension for `CAIServiceConfig` to build oauth observer (see next code snippet for implementation details)
if let observer = CAIServiceConfig.buildOAuthObserver(redirectURL:  URL(string:"<serverURL>")!,
                                                       baseURL: URL(string:"<oauthBaseURL>")!,
                                                       clientId: "<clientid>",
                                                       clientSecret: "<clientSecret>") {
   session.register(observer)
}

// create CAI service config for the provided SAPURLSession and backend URL
let serviceConfig = CAIServiceConfig(urlSession: session, host: URL(string:"<backendURL>")!)
     
// Provide the message delivery object for polling
polling = PollMessageDelivery(channelId: "<channelId>", serviceConfig: serviceConfig)
   
// create CAIConversation object and use it as publisher
let dataPublisher = CAIConversation(config: serviceConfig, channel: caiChannel, messageDelivery: polling)

// set the theme
ThemeManager.shared.setCurrentTheme( CAITheme.fiori(FioriColorPalette()) )
```

Example-specific extension for `CAIServiceConfig` to build oauth observer

```swift
extension CAIServiceConfig {
    public static func buildOAuthObserver(redirectURL: URL, baseURL: URL, clientId: String, clientSecret: String) -> OAuth2Observer? {

            let compositeStore = CompositeStorage()
            do {
                let secureKeyValueStore = SecureKeyValueStore()
                try secureKeyValueStore.open(with: "cai_secure_store")
                try compositeStore.setPersistentStore(secureKeyValueStore)

                let params = OAuth2AuthenticationParameters(authorizationEndpointURL: baseURL.appendingPathComponent("/oauth/authorize"),
                                                            clientID: clientId,
                                                            redirectURL: redirectURL.appendingPathComponent("login/callback"),
                                                            tokenEndpointURL: baseURL.appendingPathComponent("/oauth/token"),
                                                            clientSecret: clientSecret)

                let authenticator = OAuth2Authenticator(authenticationParameters: params, webViewPresenter: WKWebViewPresenter())
                let oauthObserver = OAuth2Observer(authenticator: authenticator, tokenStore: OAuth2TokenStorage(store: compositeStore))

                return oauthObserver
            }
            catch  {
                // error handling
                return nil
            }
        }
}
```

Note: it is possible to set up an `OAuth2Observer` observer for communication directly against the SAP Conversational AI tenant but it is not recommended for productive usage. To avoid shipping the CAI client secret in your iOS source code we recommend to reuse the `SAPURLSession` connecting to your SAP Mobile Services tenant and proxy requests to SAP Conversational AI through SAP Mobile Services. On SAP Mobile Services you can exchange the user token or use CAI client credentials securely.

### User Interface

Using the SwiftUI implementation is the **preferred** approach

```Swift
AssistantView()
  .navigationBarTitle(Text("Chat"), displayMode: .inline) // if you are in navigation controller
  .environmentObject(MessagingViewModel(publisher: dataPublisher)
  .environmentObject(themeManager)
  
```

but `SAPCAI` also provides a UIKit wrapper

```Swift
let vc = MessagingViewController(MessagingViewModel(publisher: dataPublisher))

self.navigationController?.pushViewController(vc, animated: true)
```

## Theming

One key aspect of the SDK is to provide as much flexibility as possible when it comes to customizing the look N feel of any UI components.

As of iOS 13, Apple allow users to change their preferences and switch between a light and a dark mode. A theme must leverage the user's preferences and adapt to the light or dark mode.

`SAPCAI` will provide two standard themes
- a default theme (Apple standard) and
- a Fiori (SAP Fiori Design Language) theme
  
Each theme will come with its color palette, that supports both light and dark mode.

You can also provide an alternative color palette or provide a custom theme.

```Swift
ThemeManager.shared.setCurrentTheme( CAITheme.default(DefaultColorPalette()) ) 	// Apple design

ThemeManager.shared.setCurrentTheme( CAITheme.fiori(FioriColorPalette()) ) 		// SAP Fiori design
```

# Limitations

## Markdown related

- **No support for [GitHub Flavored Markdown](https://github.github.com/gfm/)** (e.g. ~~strikethrough~~). Bot responses containing [Markdown](https://help.sap.com/viewer/a4522a393d2b4643812b7caadfe90c18/latest/en-US/3a3b6e09e96249b884dcf6e69eecd830.html#loio3a3b6e09e96249b884dcf6e69eecd830__section_markdown) will be rendered by the `AssistantView` according to the [Commonmark specification](https://spec.commonmark.org/0.29/) only and unknown syntax will be treated as text. 

## Trigger Skill button related

- `Trigger Skill` buttons are still enabled after execution / next interaction. This behavior differs from SAP CAI WebClient as once you click the button or type an utterance, the corresponding skill can't be triggered anymore at a later point in time, since the context in which it was created might not be valid anymore.

## Image related

- Not being able to save, copy, or share an image as part of a bot reponse. Currently there is no gesture handler attached an image view which  could allow to open a contextual menu offering such features (similar to iMessage or WhatsApp).
- Animated images (GIF), as part of a bot response, will be viewed as static image (dependency to https://github.com/dmytro-anokhin/url-image/issues/43)
