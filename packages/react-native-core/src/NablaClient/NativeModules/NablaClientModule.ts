import { NativeModule, NativeModules, Platform } from 'react-native';
import { NetworkConfiguration } from '../../types';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaClientModule extends NativeModule {
  initialize(apiKey: string, enableReporting: boolean, networkConfiguration?: NetworkConfiguration): Promise<void>;
  willAuthenticateUser(userId: string): void;
  provideTokens(refreshToken: string, accessToken: string): void;
}

export const nablaClientModule: NablaClientModule =
  NativeModules.NablaClientModule
    ? NativeModules.NablaClientModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
