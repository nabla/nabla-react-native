import { AuthTokens, NetworkConfiguration } from '../types';
import { NativeEventEmitter } from 'react-native';
import { nablaClientModule } from './NablaClientModule';

const emitter = new NativeEventEmitter(nablaClientModule);

export class NablaClient {
  private static instance: NablaClient;

  private constructor() {}

  public static getInstance(): NablaClient {
    if (!NablaClient.instance) {
      NablaClient.instance = new NablaClient();
    }

    return NablaClient.instance;
  }

  public initialize(
    apiKey: string,
    networkConfiguration: NetworkConfiguration | undefined = undefined,
  ) {
    nablaClientModule.initialize(apiKey, networkConfiguration);
  }

  public authenticate(
    userId: string,
    provideAuthTokens: () => Promise<AuthTokens>,
  ) {
    nablaClientModule.willAuthenticateUser(userId);
    emitter.addListener('needProvideTokens', async () => {
      const authTokens = await provideAuthTokens();
      nablaClientModule.provideTokens(
        authTokens.refreshToken,
        authTokens.accessToken,
      );
    });
  }
}
