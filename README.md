<div>
  <p align="center">
    <img width=20% src="https://www.sap.com/content/dam/application/imagelibrary/pictograms/283000/283370-pictogram-purple.svg" alt="Logo" />
    </br>
    <span><b>SAP Conversational AI SDK for iOS</b></span>
  </p>
  <hr>
  <div align="center">
    <a href="https://github.com/SAP/cloud-sdk-ios-cai#installation">Installation
    </a>
    |
    <a href="https://github.com/SAP/cloud-sdk-ios-cai#examples"> Examples
    </a>
    |
    <a href="https://sap.github.io/cloud-sdk-ios-cai"> API Documentation
    </a>
    |
    <a href="https://github.com/SAP/cloud-sdk-ios-cai/blob/main/CHANGELOG.md"> Changelog
    </a>
  </div>
  <hr>
  <div align="center">
    <a href="https://github.com/SAP/cloud-sdk-ios-cai/actions?query=workflow%3A%22CI%22">
    <img src="https://github.com/SAP/cloud-sdk-ios-cai/workflows/CI/badge.svg"
      alt="Build Status">
    </a>
    <a href="https://conventionalcommits.org">
    <img src="https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg"
      alt="Conventional Commits">
    </a>
    <a href="http://commitizen.github.io/cz-cli/">
    <img src="https://img.shields.io/badge/commitizen-friendly-brightgreen.svg"
      alt="Commitizen friendly">
    </a>
    <a href="https://api.reuse.software/info/github.com/SAP/cloud-sdk-ios-cai">
    <img src="https://api.reuse.software/badge/github.com/SAP/cloud-sdk-ios-cai"
      alt="REUSE status">
    </a>
    <hr>
  </div>
</div>

The `SAPCAI` Swift Package is a module to connect to a bot on the end-to-end chatbot platform [SAP Conversational AI](https://www.sap.com/products/conversational-ai.html) (CAI). It provides a pluggable SwiftUI `AssistantView` to initiate a conversation and render the various [message types](https://help.sap.com/viewer/a4522a393d2b4643812b7caadfe90c18/latest/en-US/ad3681adae824f8a96cbcf8b889a4ffc.html) of a bot.

This Swift Package is an open-source addition to the [SAP BTP SDK for iOS](https://developers.sap.com/topics/sap-btp-sdk-for-ios.html).

<p align="center">
<img src="https://user-images.githubusercontent.com/4176826/118739439-558fdd80-b7fe-11eb-9db2-032e210c5746.gif" alt="SwiftUI AssistantView" width="300" height="650" align="center">
</p>

## Requirements

Latest version
- iOS 14 or higher
- Xcode 12 (Swift 5.3) or higher

<details>
  <summary><strong>Previous versions</strong></summary>

Version 1.0.x
- iOS 13 or higher
- Xcode 12 (Swift 5.3) or higher

</details>

## Prerequisites

- You have existing bot(s) on the SAP Conversational AI platform
- You have created an OAuth client for Designtime API for your bot (<kbd>Settings</kbd> > <kbd> Tokens</kbd>)
- Your bot(s) are connected to a mobile channel

### Create a Mobile Channel

In SAP Conversational AI you create a mobile channel via the "Connect" tab of your bot.

<img width="1093" alt="CreateMobileChannel" src="https://user-images.githubusercontent.com/4176826/119203198-549dbc80-ba47-11eb-8b65-d813324c3cc8.png">

<img alt="CreateMobileChannelResults" src="https://user-images.githubusercontent.com/4176826/119582931-6a2e2180-bd7a-11eb-8faf-1b801a03d146.png">

## Dependencies

- [SAPCommon](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/Latest/en-US/Documents/Frameworks/SAPCommon/index.html) for Logging
- [SAPFoundation](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/Latest/en-US/Documents/Frameworks/SAPFoundation/index.html) for Network Connectivity and Authentication
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) for asynchronous image loading and gif animation in SwiftUI
- [Down](https://github.com/johnxnguyen/Down) for Markdown / CommonMark rendering in Swift

## Installation

The package is intended for consumption via Swift Package Manager. To add `SAPCAI` to your application target, navigate to the  <kbd>File </kbd> >  <kbd>Add Packages... </kbd> >. Use the <kbd>Search or Enter Package URL</kbd> field to find the package using the repository URL https://github.com/SAP/cloud-sdk-ios-cai.

You can choose one of the following package products to be added to your application/framework target.

|Package Product|When to Use
|---|---|
|SAPCAI|You did not already embed binary frameworks from SAP BTP SDK for iOS|
|SAPCAI-requiresToEmbedXCFrameworks|You already embedded `SAPCommon` and `SAPFoundation` binary frameworks to your target|

## Getting Started

The code snippet below illustrates setting up the `CAIConversation` Combine publisher to initialize the `MessagingViewModel` for the `AssistantView`. For prototyping you can connect the iOS client directly with SAP Conversational AI *Community Edition*. You have to replace variable values in angle brackets (e.g. `<channelId>`) with your bot-specific values.

See the [Enterprise Configuration](https://github.com/SAP/cloud-sdk-ios-cai/blob/main/ENTERPRISE_CONFIG.md) guide for the required configuration steps to use `SAPCAI` Swift package and connect indirectly with SAP Conversational AI *Enterprise Edition* through SAP Mobile Services.

### Setting up the Data Publisher

```Swift
import SAPCAI
import SAPFoundation
import SwiftUI

/*
  Create the `CAIChannel` object by providing the channel id, channel token, and channel slug of your mobile channel. Values can be looked up in CAI platform.

  If you do not want to hardcode channel information on the client, you can retrieve a list of channels for a given Application ID with `CAIChannelService`.
*/
let caiChannel = CAIChannel(id: "<channelId>", token: "<channelToken>", slug: "<channelSlug>")

// Create CAI service config for a SAPURLSession and URL pointing to CAI API endpoint
let serviceConfig = CAIServiceConfig(urlSession: SAPURLSession(), host: URL(string:"<Example: https://api.cai.tools.sap>")!)
     
// Provide the message delivery object for polling
let polling: MessageDelivering = PollMessageDelivery(channelId: "<channelId>", serviceConfig: serviceConfig)
   
// Create CAIConversation object and use it as publisher
let dataPublisher = CAIConversation(config: serviceConfig, channel: caiChannel, messageDelivery: polling)

// Create view model for `AssistantView`
let viewModel = MessagingViewModel(publisher: dataPublisher)
```

### User Interface

Using the SwiftUI implementation is the **preferred** approach.

```Swift
// `NavigationView` must be present in your view hierachy as `AssistantView` makes use of `NavigationLink`
AssistantView()
  .navigationTitle(Text("Chat")) // if you are in navigation controller
  .environmentObject(viewModel)
  .environmentObject(ThemeManager.shared)
  .onDisappear {
    // you cannot rely on the fact that onDisappear will be called only
    // once because `AssistantView` might trigger further navigations
    // causing the `AssistantView` to disappear and re-appear.
    // Therefore cleanup logic should be handled elsewhere.
  })
```

but `SAPCAI` also provides a UIKit wrapper

```Swift
let vc = MessagingViewController(MessagingViewModel(publisher: dataPublisher))

self.navigationController?.pushViewController(vc, animated: true)
```

### Cleanup

Once a conversation has ended you need to call the following functions to avoid memory leaks and unnecessary network requests. Also `MessagingViewModel` cannot be deallocated otherwise.

```swift
viewModel.cancelSubscriptions()
dataPublisher.resetConversation()
```

SAPCAI uses `SDWebImage` and its image caching capabilities but it is the app developers responsibility to clear the cache if that is desired. Example:
```Swift
SDImageCache.shared.clearMemory()
SDImageCache.shared.clearDisk(onCompletion: nil)
```

## Theming

`SAPCAI` will provide two standard themes
- a Fiori theme and
- a Casual theme (**no longer maintained**)

<img width="663" alt="Themes" src="https://user-images.githubusercontent.com/4176826/119032300-e1217f80-b960-11eb-8d65-e068958aff36.png">

Each theme will come with a color palette that supports both light and dark modes.

### Fiori Theme

```swift
ThemeManager.shared.setCurrentTheme( .fiori(FioriColorPalette()) )
```

### Casual Theme

**No longer maintained and therefore marked as deprecated. Do not use!**
    
```swift
ThemeManager.shared.setCurrentTheme( .casual(CasualColorPalette()) )
```

### Create Your Own Custom Theme

You can also provide an alternative color palette or provide a custom theme.

## Persistent Static Menu

In SAP Conversational AI you can add persistent static menu options to your chatbot enabling your users to quickly trigger links or skills at any point during the conversation.

<img width="525" alt="Persistent Static Menu In Bot Builder" src="https://user-images.githubusercontent.com/4176826/146964912-6cceec20-ea57-4bda-90f1-b6fa339eb470.png">

Use `CAIChannelService.loadPreferences` to fetch your channel's preferences (incl. the persistent static menu) asynchronously, then set `MessagingViewModel.menu`.

```Swift
service.loadPreferences(channel: channel) { result in
  DispatchQueue.main.async {
    switch result {
      case .success(let data):
        viewModel.menu = data?.menu
      case .failure:
        break
    }
  }
}
```

![Persistent Static Menu Rendered by SAP CAI SDK for iOS](https://user-images.githubusercontent.com/4176826/146965541-0288dfe5-99bf-47e9-9779-d196583d6253.png)


## Limitations

### Markdown Related

- **No support for [GitHub Flavored Markdown](https://github.github.com/gfm/)** (e.g. ~~strikethrough~~). Bot responses containing [Markdown](https://help.sap.com/viewer/a4522a393d2b4643812b7caadfe90c18/latest/en-US/3a3b6e09e96249b884dcf6e69eecd830.html#loio3a3b6e09e96249b884dcf6e69eecd830__section_markdown) will be rendered by the `AssistantView` according to the [Commonmark specification](https://spec.commonmark.org/0.29/) only, and unknown syntax will be treated as text. 

### Trigger Skill Button Related

- `Trigger Skill` buttons are still enabled after execution / next interaction. This behavior differs from the SAP CAI Web Client. Once you click the button or type an utterance, the corresponding skill can't be triggered anymore at a later point in time since the context in which it was created might not be valid anymore.

### Image Related

- Not being able to save, copy, or share an image as part of a bot response. Currently, there is no gesture handler attached to an image view which could allow opening a contextual menu offering such features (similar to iMessage or WhatsApp).

## How to Obtain Support

Please [raise an issue on GitHub](https://github.com/SAP/cloud-sdk-ios-cai/issues/new/choose). SAP customers can continue to report issues through OSS for SLA tracking.  

Raise questions around CAI in the [SAP CAI Answers](https://answers.sap.com/tags/73555000100800001301) forum.

## Contributing

If you want to contribute, please check the [Contribution Guidelines](./CONTRIBUTING.md).

## Examples

The `CAITestApp` in this repository allows you to
- choose a theme
- view static mock data or
- connect against a live system by either
  - letting the user choose the mobile channel from the list of available mobile channels for given Application ID (a.k.a targetSystem); note: this illustrates the use of `CAIChannelService` and how to build a simple SwiftUI view on top of it
  - loading the `AssistantView` for a specific mobile channel

See [here](https://github.com/SAP/cloud-sdk-ios-cai/tree/main/CAITestApp) on how to maintain connection settings for the test application.
