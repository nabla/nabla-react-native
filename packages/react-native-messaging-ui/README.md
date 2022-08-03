# Nabla Messaging UI SDK

## Documentation

Check our [documentation portal](https://docs.nabla.com/) for in depth documentation about integrating and using the SDK.

## Installation

```sh
npm install --save '@nabla/react-native-messaging-ui'
```

Or

```sh
yarn add '@nabla/react-native-messaging-ui'
```

## Usage

### NablaMessagingUIClient

```ts
import { NablaMessagingUI } from '@nabla/react-native-messaging-ui';

NablaMessagingUI.navigateToInbox();

// You can use retrieve the `conversationId` from using `watchConversations` in mnessaging core using your server API.
NablaMessagingUI.navigateToConversation(conversationId);
```

## License

MIT
