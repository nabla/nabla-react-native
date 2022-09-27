import { NativeModule, NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@nabla/react-native-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface LogWatcherModule extends NativeModule {
  setLogLevel(level: string): void
}

export const logWatcherModule: LogWatcherModule =
  NativeModules.LogWatcherModule
    ? NativeModules.LogWatcherModule
    : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      },
    );
