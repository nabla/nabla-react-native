import { NativeModule, NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@nabla/react-native-scheduling' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaSchedulingClientModule extends NativeModule {
  initializeSchedulingModule(): Promise<void>;
}

export const nablaSchedulingClientModule: NablaSchedulingClientModule =
  NativeModules.NablaSchedulingClientModule
    ? NativeModules.NablaSchedulingClientModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
