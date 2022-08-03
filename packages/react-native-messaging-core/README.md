# Nabla Messaging Core SDK

## Documentation

Check our [documentation portal](https://docs.nabla.com/) for in depth documentation about integrating and using the SDK.

## Installation

```sh
npm install --save '@nabla/react-native-messaging-core'
```

```sh
yarn add '@nabla/react-native-messaging-core'
```

## Usage

### NablaMessagingClient

```ts
import { NablaMessagingClient } from '@nabla/react-native-messaging-core';

const nablaMessagingClient = NablaMessagingClient.getInstance();

const subscription = nablaMessagingClient.watchConversations(
  (error) => {
    subscription.remove();
    // ...
  },
  (list) => {
    /* */
  },
);

nablaMessagingClient.loadMoreConversations(
  (error) => {
    /* ... */
  },
  () => {
    /* ... */
  },
);

nablaMessagingClient.createConversation(
  (error) => {
    /* ... */
  },
  (conversationId) => {
    /* ... */
  },
  title,
  providerId,
);
```

## License

MIT
