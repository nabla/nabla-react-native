# Nabla Core SDK

## Documentation

Check our [documentation portal](https://docs.nabla.com/) for in depth documentation about integrating and using the SDK.

## Installation

```sh
npm install --save '@nabla/react-native-core'
```

Or

```sh
yarn add '@nabla/react-native-core'
```

## Usage

### NablaClient

```ts
import { NablaClient } from '@nabla/react-native-messaging-core';

NablaClient.getInstance().initialize(apiKey);

NablaClient.getInstance().authenticate(userId, async () => {
  // Fetch current user authentication tokens from your server
  // See server side documentation https://docs.nabla.com/reference/api-getting-started for more details.
  return new AuthTokens(refreshToken, accessToken);
});
```

## License

MIT
