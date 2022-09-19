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

### NablaClient

```ts
import { NablaVideoCallClient } from '@nabla/react-native-video-call';

// To initialize the video call module, you will need to call this method before `NablaClient.getInstance.initialize`:
await NablaVideoCallClient.initializeVideoCallModule()

// To join a video call room `VideoCallRoom`
NablaVideoCallClient.joinVideoCallRoom(
  room,
  errorCallback,
  successCallback
)
```

## License

MIT
