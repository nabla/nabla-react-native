# Changelog

## [Unreleased]

### Added

- `NablaMessagingClient.markConversationAsSeen` to notify the server that the patient has seen the conversation.
- `NablaMessagingClient.deleteMessage` to delete a message in a conversation.
- `NablaMessagingClient.watchItemsOfConversation` to watch conversation items with a given `conversationId`.
- `NablaMessagingClient.watchConversation` to watch a conversation with a given id.

### Changed

- `Conversation.id` is now a `ConversationId` type instead of a `string` type. 

### Fixed

### Versions

- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaMessagingUI', '1.0.0-alpha14'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaMessagingCore', '1.0.0-alpha14'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaCore', '1.0.0-alpha14'`

## [1.0.0-alpha02] - 2022-08-11

### Added

### Changed

### Fixed

- React Native modules auto linking is now working on iOS.   

### Versions

- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaMessagingUI', '1.0.0-alpha14'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaMessagingCore', '1.0.0-alpha14'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaCore', '1.0.0-alpha14'`

## [1.0.0-alpha01] - 2022-08-08

### Added

- First public version of the SDK

### Versions

- `@nabla/react-native-messaging-ui`
  - Android: `com.nabla.nabla-android:messaging-ui:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaMessagingUI', '1.0.0-alpha13'`
- `@nabla/react-native-messaging-core`
  - Android: `com.nabla.nabla-android:messaging-core:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaMessagingCore', '1.0.0-alpha13'`
- `@nabla/react-native-core`
  - Android: `com.nabla.nabla-android:core:1.0.0-alpha09`
  - iOS: `spec.dependency 'NablaCore', '1.0.0-alpha13'`
