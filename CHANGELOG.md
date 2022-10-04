# Changelog

## [Unreleased]

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

- `@nabla/react-native-scheduling`
  - Android: `com.nabla.nabla-android:scheduling:1.0.0-alpha13"`
  - iOS: `pod 'NablaScheduling', '1.0.0-alpha18'`
- `@nabla/react-native-video-call`
  - Android: `com.nabla.nabla-android:video-call:1.0.0-alpha13"`
  - iOS: `pod 'NablaVideoCall', '1.0.0-alpha18'`
- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha13`
  - iOS: `pod 'NablaMessagingUI', '1.0.0-alpha18'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha13`
  - iOS: `pod 'NablaMessagingCore', '1.0.0-alpha18'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha13`
  - iOS: `pod 'NablaCore', '1.0.0-alpha18'`

## [1.0.0-alpha04] - 2022-09-19

### Added

- Created `@nabla/react-native-scheduling` package

### Changed

- Updated native dependencies to latest versions.

### Fixed

- Fixed `NablaMessagingClient.createConversation` success callback parameter being undefined 

### Versions

- `@nabla/react-native-scheduling`
  - Android: `com.nabla.nabla-android:scheduling:1.0.0-alpha12"`
  - iOS: `pod 'NablaScheduling', '1.0.0-alpha17'`
- `@nabla/react-native-video-call`
  - Android: `com.nabla.nabla-android:video-call:1.0.0-alpha12"`
  - iOS: `pod 'NablaVideoCall', '1.0.0-alpha17'`
- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha12`
  - iOS: `pod 'NablaMessagingUI', '1.0.0-alpha17'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha12`
  - iOS: `pod 'NablaMessagingCore', '1.0.0-alpha17'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha12`
  - iOS: `pod 'NablaCore', '1.0.0-alpha17'`

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

- `@nabla/react-native-video-call`
  - Android: `com.nabla.nabla-android:video-call:1.0.0-alpha10`
  - iOS: `pod 'NablaVideoCall', '1.0.0-alpha16'`
- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha10`
  - iOS: `pod 'NablaMessagingUI', '1.0.0-alpha16'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha10`
  - iOS: `pod 'NablaMessagingCore', '1.0.0-alpha16'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha10`
  - iOS: `pod 'NablaCore', '1.0.0-alpha16'`

## [1.0.0-alpha02] - 2022-08-11

### Added

### Changed

### Fixed

- React Native modules auto linking is now working on iOS.   

### Versions

- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha09`
  - iOS: `pod 'NablaMessagingUI', '1.0.0-alpha14'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha09`
  - iOS: `pod 'NablaMessagingCore', '1.0.0-alpha14'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha09`
  - iOS: `pod 'NablaCore', '1.0.0-alpha14'`

## [1.0.0-alpha01] - 2022-08-08

### Added

- First public version of the SDK

### Versions

- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha09`
  - iOS: `pod 'NablaMessagingUI', '1.0.0-alpha13'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha09`
  - iOS: `pod 'NablaMessagingCore', '1.0.0-alpha13'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha09`
  - iOS: `pod 'NablaCore', '1.0.0-alpha13'`
