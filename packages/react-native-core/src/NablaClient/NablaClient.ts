import { AuthTokens, NetworkConfiguration } from '../types';
import { NativeEventEmitter } from 'react-native';
import { nablaClientModule } from './NablaClientModule';

const emitter = new NativeEventEmitter(nablaClientModule);

/**
 * Main entry-point to SDK-wide features.
 */
export class NablaClient {
  private static instance: NablaClient;

  private constructor() {}

  /**
   * Shared instance of NablaClient client to use.
   * Always call ``NablaClient.getInstance().initialize(apiKey:)`` before using it.
   */
  public static getInstance(): NablaClient {
    if (!NablaClient.instance) {
      NablaClient.instance = new NablaClient();
    }

    return NablaClient.instance;
  }

  /**
   * NablaClient initializer, you must call this method before using `NablaClient.getInstance()`.
   * You must call this method only once.
   *
   * @param apiKey Your organisation's API key (created online on Nabla dashboard).
   * @param networkConfiguration optional network configuration, exposed for internal tests purposes and should not be used in your app.
   */
  public async initialize(
    apiKey: string,
    networkConfiguration: NetworkConfiguration | undefined = undefined,
  ) {
    await nablaClientModule.initialize(apiKey, networkConfiguration);
  }

  /**
   * Authenticate the current user.
   * @param userId Identifies the user between sessions.
   * @param provideAuthTokens `AuthTokens` provider.
   */
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
