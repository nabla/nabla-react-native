# @nabla/react-native-messaging-core

Nabla Messaging Core

## Installation

```sh
npm install --save '@nabla/react-native-messaging-ui'
```

## Usage

### NablaMessagingUIClient

```ts
import { NablaMessagingUIClient } from '@nabla/react-native-messaging-ui';

const nablaMessagingUIClient = NablaMessagingUIClient.getInstance();

// You can use retrieve the `conversationId` from using `watchConversations` in mnessaging core using your server API.
nablaMessagingUIClient.navigateToConversation(conversationId);
```

## License

MIT
