# Changelog

## [Unreleased]

### Added

### Changed

### Fixed

### Versions

- Android: [`1.0.0-alpha19`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha19)
- iOS: [`1.0.0-alpha24`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha24)

## [1.0.0-alpha09] - 2022-11-17

### Added

- Reporting: an ErrorReporter was added to the native SDKs to report anonymous events to nabla servers to help debug some features like video calls. 
  
  ⚠️To update to this version you need to add a new pod in the `ios/Podfile`
  ```ruby
    pod 'Sentry', :modular_headers => true
  ```
  (You can find more info in the [documentation](https://docs.nabla.com/docs/init-rn#add-the-dependency))

### Changed

- Theming: the native SDKs updates contain an enhanced handling of the dark/night modes.

- Removed the `showComposer` parameter from `NablaMessagingUI.navigateToConversation` method and relied on `Conversation` `isLocked` property to hide the composer.  
  ⚠️ If you were using the `showComposer` parameter of `NablaMessagingUI.navigateToConversation`, it is not available anymore, and you should migrate to using lock conversation from the Console.

- The `NablaClient.initialize` method now takes a `Configuration` class instead of multiple parameters.
  ⚠️ This change is breaking and you will need to update all `NablaClient` `initialize`.

### Fixed

### Versions

- Android: [`1.0.0-alpha19`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha19)
- iOS: [`1.0.0-alpha24`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha24)

## [1.0.0-alpha08] - 2022-11-04

### Added

- New Messaging UI feature: You can now scan (with the camera) and send multi-page documents in conversations.
- Added a new `pictureURL` attribute on `Conversation` type. 
- Added support for group chats with multiple patients and providers.
  + A new `ConversationItemSender` `Patient` type was introduced for conversations with multiple patients.
  + `ConversationItemSender` `Patient` type was rename to `Me`.

### Changed

### Fixed

- Disambiguate the `Logger` protocol usage iOS Core pod.  

### Versions

- Android: `1.0.0-alpha18`
- iOS: `1.0.0-alpha21`

## [1.0.0-alpha07] - 2022-10-18

### Versions

- Android: `1.0.0-alpha15`
- iOS: `1.0.0-alpha20`

## [1.0.0-alpha06] - 2022-10-14

### Added

- Added optional `dismissCallback` to `navigateToInbox` in `NablaMessagingUI`.

### Changed

- Optional `successCallback` in `navigateToConversation` is now `dismissCallback` in `NablaMessagingUI`.
- ReactNativeSampleApp app has been renamed to `Messaging Sample App` to better reflect what it showcases.

### Fixed

- Fixed an issue that prevent success callback from being called when the result is `void`.

### Versions

- Android: `1.0.0-alpha15`
- iOS: `1.0.0-alpha19`

## [1.0.0-alpha05] - 2022-10-07

### Added

- Added `Logger` interface with a default `ConsoleLogger` implementation to display react native and native logs.
- Added optional error and success callbacks in `NablaMessagingUI.navigateToConversation`
- Added `NablaMessagingClient.retrySendingMessage` in `NablaMessagingCore`
- Added `initialMessage` param to `NablaMessagingClient.createConversation` in `NablaMessagingCore`
- Added `NablaMessagingClient.createDraftConversation` to `NablaMessagingCore`

### Changed

### Fixed

- [_Android_] Fixed sample app backward compatibility by enabling desugaring
- [_iOS_] Fixed some colors when the phone is in Dark appearance

### Versions

- Android: `1.0.0-alpha13`
- iOS: `1.0.0-alpha19`

## [1.0.0-alpha04] - 2022-09-19

### Added

- Created `@nabla/react-native-scheduling` package

### Changed

- Updated native dependencies to latest versions.

### Fixed

- Fixed `NablaMessagingClient.createConversation` success callback parameter being undefined 

### Versions

- Android: `1.0.0-alpha12`
- iOS: `1.0.0-alpha17`

## [1.0.0-alpha03] - 2022-09-08

### Added

- Created `@nabla/react-native-video-call` package
- `NablaMessagingClient.setIsTyping` to notify the server that the patient is typing in the conversation.
- `NablaMessagingClient.markConversationAsSeen` to notify the server that the patient has seen the conversation.
- `NablaMessagingClient.deleteMessage` to delete a message in a conversation.
- `NablaMessagingClient.watchItemsOfConversation` to watch conversation items with a given `conversationId`.
- `NablaMessagingClient.watchConversation` to watch a conversation with a given id.

### Changed

- Added `NablaMessagingClient.initializeMessagingModule` and `NablaVideoCallClient.initializeVideoCallModule` to enable the corresponding modules.
- `Conversation.id` is now a `ConversationId` type instead of a `string` type. 

### Fixed

- Fixed `onConversationSelected` callback param in `ConversationListView` to send a `ConversationId` instead of a `string`.
- Fixed `ConversationItem` type definition by adding `createdAt` property to `ConversationMessage`.

### Versions

- Android: `1.0.0-alpha10`
- iOS: `1.0.0-alpha16`

## [1.0.0-alpha02] - 2022-08-11

### Added

### Changed

### Fixed

- React Native modules auto linking is now working on iOS.   

### Versions

- Android: `1.0.0-alpha09`
- iOS: `1.0.0-alpha14`

## [1.0.0-alpha01] - 2022-08-08

### Added

- First public version of the SDK

### Versions
 
- Android: `1.0.0-alpha09`
- iOS: `1.0.0-alpha13`
