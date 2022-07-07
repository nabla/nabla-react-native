# @nabla/react-native-messaging-core

Nabla Messaging Core

## Installation

```sh
npm install --save '@nabla/react-native-messaging-core' 
```

## Usage

### NablaClient
```ts
import { NablaClient } from '@nabla/react-native-messaging-core'

NablaClient.getInstance().initialize(
  apiKey
)

NablaClient.getInstance().authenticate(userId, async () => {
    // await ...
    return new AuthTokens(refreshToken, accessToken)
})
```

### NablaMessagingClient
```ts
import { NablaMessagingClient } from '@nabla/react-native-messaging-core'

const nablaMessagingClient = NablaMessagingClient.getInstance()

const subscription = nablaMessagingClient.watchConversations(
  (error) => {
    subscription.remove()
    // ...
  },
  (list) => { /* */ }
)

nablaMessagingClient.loadMoreConversations(
    (error) => { /* ... */ },
    () => { /* ... */ }
)

nablaMessagingClient.createConversation(
    (error) => { /* ... */ },
    (conversationId) => { /* ... */ },
    title,
    providerId
)
```

## License

MIT
