# Changelog

## [Unreleased]

### Added

### Changed

### Fixed

### Versions

- Android: [`1.0.0-alpha25`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha25)
- iOS: [`1.0.0-alpha33`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha33)

## [1.0.0-alpha15] - 2023-03-07

### Added
- Scheduling: support for registering a payment step. See [doc](https://docs.nabla.com/docs/scheduling-payments-rn) for details/instructions.

### Changed
- Core: `NablaClient.authenticate` is replaced by `NablaClient.setCurrentUserOrThrow` and `NablaClient.clearCurrentUser`. `provideAuthTokens` is set during `NablaClient.initialize`.

### Fixed

### Versions

- Android: [`1.0.0-alpha25`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha25)
- iOS: [`1.0.0-alpha33`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha33)

## [1.0.0-alpha14] - 2023-02-22

### Added

- Messaging Core: Added a new `Response` object returned by watchers. It contains metadata about the freshness of the data returned, allowing the caller to know if the data comes from cache or is fresh and if a background refresh is in progress.

### Changed

- Messaging Core: `watchConversation` success callback is now called with a `Response<Conversation>, NablaError>`.
- Messaging Core: `watchItemsOfConversation` success callback is now called with a `Response<PaginatedList<ConversationItem>, NablaError>`.
- Messaging Core: `watchConversations` success callback is now called with a `Response<PaginatedList<Conversation>> NablaError>`.

### Fixed

- Core: fixed a crash that occurred on iOS when authenticating a different user or the same user multiple times. 
- Messaging Core: Fixed `createConversationWithMessage` not correctly setting providerIds on Android.

### Versions

- Android: [`1.0.0-alpha24`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha24)
- iOS: [`1.0.0-alpha32`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha32)

## [1.0.0-alpha13] - 2023-01-30

### Added

- A new `onAppointmentSelected` property is available in `NablaAppointmentListView` component and should be provided to redirect to the appointment detail screen (`NablaSchedulingUI.navigateToAppointmentDetailScreen(appointmentId)`).
(This callback will only be used on iOS and the navigation will work as expected on Android)

### Changed

- `NablaSchedulingClient.openScheduleAppointmentScreen()` has been renamed to `NablaSchedulingUI.navigateToScheduleAppointmentScreen()` in the NablaScheduling package. 

### Fixed

### Versions

- Android: [`1.0.0-alpha22`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha22)
- iOS: [`1.0.0-alpha30`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha30)

## [1.0.0-alpha12] - 2023-01-02

### Versions

- Android: [`1.0.0-alpha21`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha21)
- iOS: [`1.0.0-alpha29`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha29)

## [1.0.0-alpha11] - 2022-12-14

### Added

### Changed

- Messaging Core: Renamed `createDraftConversation` to `startConversation`. It keeps the behavior of creating the conversation lazily when the patient sends the first message.
- Messaging Core: `createConversation` has been renamed `createConversationWithMessage` and now has a required `message` argument. It should be used to start a conversation on behalf of the patient with a first message from them.

### Fixed
 
- Fixed some cases in MessagingCore where the success callback was called too in addition to the error callback when the method fails.

### Versions

- Android: [`1.0.0-alpha21`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha21)
- iOS: [`1.0.0-alpha28`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha28)


## [1.0.0-alpha10] - 2022-11-25

### Added

- The conversation screen is now available as a React Native `Component`: `NablaConversationView`.

### Changed

- Updated the iOS native SDK dependency to `1.0.0-alpha26`.
- Updated the Android native SDK dependency to `1.0.0-alpha20`.
> The Android SDK now targets API 33, meaning you should bump your `compileSdkVersion` in the Android project to be 33 or higher (this doesn't impact your app's minimum Android supported version).

### Fixed

### Versions

- Android: [`1.0.0-alpha20`](https://github.com/nabla/nabla-android/releases/tag/1.0.0-alpha20)
- iOS: [`1.0.0-alpha26`](https://github.com/nabla/nabla-ios/releases/tag/1.0.0-alpha26)

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
