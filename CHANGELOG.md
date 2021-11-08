# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [2.0.0](https://github.com/SAP/cloud-sdk-ios-cai/compare/1.0.4...2.0.0) (2021-11-10)

### ⚠ BREAKING CHANGES

* 🧨 new minimum deployment target is iOS 14 (previously: iOS 13)
* 🧨 [SDWebImage](https://github.com/SDWebImage/SDWebImage) replaces [URLImage](https://github.com/dmytro-anokhin/url-image) as package dependency 
* 🧨 no cleanup logic in `onDisappear` !! 

  For previous release(s) it was suggested to implement cleanup logic in `onDisappear` but you cannot rely that `onDisappear` will be called only once. The `AssistantView` might trigger further navigations causing the `AssistantView` to disappear and re-appear. Therefore cleanup logic should be handled elsewhere.
* 🧨 `NavigationView` is required in view hierarchy.

### Features

* 🎸 CardPageView to be used in Carousel and List ([a585c84](https://github.com/SAP/cloud-sdk-ios-cai/commit/a585c84cc16125263424f7b4fbc7d373d986ca6c))
* 🎸 carousel image: support sap-icon ([a1ef423](https://github.com/SAP/cloud-sdk-ios-cai/commit/a1ef423dcd6bd7b020809ec2e9567e8e3e2a13d5))
* 🎸 expandable plain long text messages with "View more" button ([#42](https://github.com/SAP/cloud-sdk-ios-cai/issues/42)) ([7437316](https://github.com/SAP/cloud-sdk-ios-cai/commit/7437316fee74f8bee11a9fbe1a902dc0f27b026c))
* 🎸 gif supported through SDWebImage ([#32](https://github.com/SAP/cloud-sdk-ios-cai/issues/32)) ([8280053](https://github.com/SAP/cloud-sdk-ios-cai/commit/8280053136dc4bebfd3f0aaa2009feace77c9bcf))


### Bug Fixes

* 🐛 resolve cycle reference for conversation operation ([3310416](https://github.com/SAP/cloud-sdk-ios-cai/commit/331041683d504fa4a29792e2bd8581f51f113ebf))
* 🐛 UI improvement for spacing and heights ([#33](https://github.com/SAP/cloud-sdk-ios-cai/issues/33)) ([aa7ff09](https://github.com/SAP/cloud-sdk-ios-cai/commit/aa7ff09212a07e1c60cc7f7012e9968485141774))

## [1.0.4](https://github.com/SAP/cloud-sdk-ios-cai/compare/1.0.3...1.0.4) (2021-08-09)

### Features

* 🎸 client-side handling of delayed messages ([2d3bed2](https://github.com/SAP/cloud-sdk-ios-cai/commit/2d3bed279e16c2184de224fef2cd99b057abab1c))
* 🎸 delayed message(s) are visually announced ([5015477](https://github.com/SAP/cloud-sdk-ios-cai/commit/5015477c39c54a03f1180b7291f773eede1fb2c2))


### Bug Fixes

* 🐛 "Trigger Skill" button inside card posts data correctly ([da9a309](https://github.com/SAP/cloud-sdk-ios-cai/commit/da9a3098048a38707287050b3041d50da525a16b))
* 🐛 action button layout for different size class ([#27](https://github.com/SAP/cloud-sdk-ios-cai/issues/27)) ([399f3b2](https://github.com/SAP/cloud-sdk-ios-cai/commit/399f3b29addb72b4a07bc84628c61aefc8fb8fcf))
* 🐛 avoid "A server error occurred" msgs related to polling ([942096a](https://github.com/SAP/cloud-sdk-ios-cai/commit/942096ae5832cfea3c2229846010a480cfe496d6))
* 🐛 avoid "Request was cancelled" error message ([9cc3907](https://github.com/SAP/cloud-sdk-ios-cai/commit/9cc3907c1ebf84d15b6bfb9858c64af1ef422fca))
* 🐛 avoid endless polling for continuous server errors ([e94482d](https://github.com/SAP/cloud-sdk-ios-cai/commit/e94482dda5ac4fb12b96031c599f53b10eec2b76))
* 🐛 fix "Failed to parse" for custom Text messages ([30bcf40](https://github.com/SAP/cloud-sdk-ios-cai/commit/30bcf40e88450da76b43dcba6effa176cae879d8))
* 🐛 handle phonenumber button type with "tel:" prefix ([#24](https://github.com/SAP/cloud-sdk-ios-cai/issues/24)) ([791f960](https://github.com/SAP/cloud-sdk-ios-cai/commit/791f9601511f0084d595f57faaba77c807900fcf))
* 🐛 Hide "view more" button for <= 5 buttons in list ([f9a2cf6](https://github.com/SAP/cloud-sdk-ios-cai/commit/f9a2cf6c44cb2006a7453b4e734a258181daad0b))
* 🐛 icon color appropiate to color scheme (dark/light) ([2744ffc](https://github.com/SAP/cloud-sdk-ios-cai/commit/2744ffca468fa5804b9feb1252659a0aeadb6f49))
* 🐛 Localize UI text "View more" ([31480bf](https://github.com/SAP/cloud-sdk-ios-cai/commit/31480bfac84b73d1b97805c879f2aada96ef27ef))
* 🐛 Localize UI texts "Clear", "Actions" and "Cancel" ([450df11](https://github.com/SAP/cloud-sdk-ios-cai/commit/450df11afb2f7f689067b3a54bac855204e27a94))
* 🐛 only show link email and phone number as clickable ([#31](https://github.com/SAP/cloud-sdk-ios-cai/issues/31)) ([395552d](https://github.com/SAP/cloud-sdk-ios-cai/commit/395552dce33c7a58187179071a581d2b057a7877))
* 🐛 show 'View More' button in list ([4540ca9](https://github.com/SAP/cloud-sdk-ios-cai/commit/4540ca98e5adf74cf9eb8040abc79617f20e9e65))
* 🐛 showing the first 11 Quick replies only ([9a1027b](https://github.com/SAP/cloud-sdk-ios-cai/commit/9a1027bd5f1ffb8436f5018c7a5c35c4df732852))
* 🐛 start polling (if paused) after user sent message to bot ([6f89298](https://github.com/SAP/cloud-sdk-ios-cai/commit/6f8929812c34add5d23ed23cfab5de73d5055aa8))
* 🐛 start polling after conversation was created ([29a4ddc](https://github.com/SAP/cloud-sdk-ios-cai/commit/29a4ddca1d18788a45ce10a62c377473fdf4b8b2))
* 🐛 UI improvement for error banner ([955be18](https://github.com/SAP/cloud-sdk-ios-cai/commit/955be18eecbc308e281df885f525afb2d3657079))

## [1.0.3](https://github.com/SAP/cloud-sdk-ios-cai/compare/1.0.2...1.0.3) (2021-06-10)

Patch version update as new feature(s) are non-breaking and do not change behavior unless app developer adopts actively

### Features

* 🎸 being able to post a message with memory options ([49ee147](https://github.com/SAP/cloud-sdk-ios-cai/commit/49ee147fe06b4a9c88ae9540362aa49259c30da4))

## [1.0.2](https://github.com/SAP/cloud-sdk-ios-cai/compare/1.0.1...1.0.2) (2021-06-04)

### Bug Fixes

* 🐛 ScrollView size/offset incorrect after loading images ([f00d6e4](https://github.com/SAP/cloud-sdk-ios-cai/commit/f00d6e44e97c858c65c027492d2169d3f7078c29)), closes [#13](https://github.com/SAP/cloud-sdk-ios-cai/issues/13)
* localized texts in 2 new language variants ([db7bd34](https://github.com/SAP/cloud-sdk-ios-cai/commit/db7bd34b402cd597271506a0c05891c8a0e8ed62)), closes [#12](https://github.com/SAP/cloud-sdk-ios-cai/issues/12), see [list of supported languages](https://github.com/SAP/cloud-sdk-ios-cai/pull/12#issuecomment-854896610) for more info

## [1.0.1](https://github.com/SAP/cloud-sdk-ios-cai/compare/1.0.0...1.0.1) (2021-06-02)

### Bug Fixes

* localized texts in 6 new languages ([02a8ce4](https://github.com/SAP/cloud-sdk-ios-cai/commit/02a8ce4d5cf63bd32396fead347f2be86a4eeadf)), closes [#10](https://github.com/SAP/cloud-sdk-ios-cai/issues/10), see [list of supported languages](https://github.com/SAP/cloud-sdk-ios-cai/pull/10#issuecomment-853270881) for more info

## [1.0.0](https://github.com/SAP/cloud-sdk-ios-cai/releases/tag/1.0.0) (2021-05-26)

- Initial release! 🎉
- Being able to initiate a conversation and render the various message types of a bot.
