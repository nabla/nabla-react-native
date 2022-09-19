# Nabla Scheduling SDK

## Documentation

Check our [documentation portal](https://docs.nabla.com/) for in depth documentation about integrating and using the SDK.

## Installation

```sh
npm install --save '@nabla/react-native-scheduling'
```

Or

```sh
yarn add '@nabla/react-native-scheduling'
```

## Usage

### NablaSchedulingClient

```ts
import { NablaSchedulingClient } from '@nabla/react-native-scheduling';

// To initialize the scheduling module, you will need to call this method before `NablaClient.getInstance.initialize`:
await NablaSchedulingClient.initializeSchedulingModule()
```

## License

MIT
