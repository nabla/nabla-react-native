# Nabla Video Call SDK

## Documentation

Check our [documentation portal](https://docs.nabla.com/) for in depth documentation about integrating and using the SDK.

## Installation

```sh
npm install --save '@nabla/react-native-video-call'
```

Or

```sh
yarn add '@nabla/react-native-video-call'
```

## Usage

### NablaVideoCallClient

```ts
import { NablaVideoCallClient } from '@nabla/react-native-video-call';

// To initialize the video call module, you will need to call this method before `NablaClient.getInstance.initialize`:
await NablaVideoCallClient.initializeVideoCallModule()
```

## License

MIT
