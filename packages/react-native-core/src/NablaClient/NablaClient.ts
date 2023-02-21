import { AuthTokens, Configuration, LogLevel, NetworkConfiguration } from '../types';
import { EmitterSubscription, NativeEventEmitter } from 'react-native';
import { nablaClientModule } from './NativeModules/NablaClientModule';
import { Logger } from './Logger';
import { ConsoleLogger } from './ConsoleLogger';
import { mapCoreError } from '../internal';
import { NativeLog } from './NativeModules/NativeLog';
import { logWatcherModule } from './NativeModules/LogWatcherModule';

const emitter = new NativeEventEmitter(nablaClientModule);
const logsEmitter = new NativeEventEmitter(
  logWatcherModule,
);


/**
 * Main entry-point to SDK-wide features.
 */
export class NablaClient {
  private static instance: NablaClient;
  private logEmitterSubscription?: EmitterSubscription;
  private needProvideTokensSubscription?: EmitterSubscription;
  private logger?: Logger;

  private constructor() {
    this.logEmitterSubscription = logsEmitter.addListener('log', async (data: NativeLog) => {
      this.handleNativeLog(data);
    });
  }

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
   * @param configuration Your organisation's configuration containing the API key (created online on Nabla dashboard).
   * @param logger logger used by the SDK. You can replace the default `ConsoleLogger` with your own implementation or adjust the log level using `setLogLevel`.
   * @param networkConfiguration optional network configuration, exposed for internal tests purposes and should not be used in your app.
   */
  public async initialize(
    configuration: Configuration,
    networkConfiguration: NetworkConfiguration | undefined = undefined,
    logger: Logger = new ConsoleLogger(),
  ) {
    this.logger = logger;
    await nablaClientModule.initialize(
      configuration.apiKey,
      configuration.enableReporting,
      networkConfiguration);
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
    this.needProvideTokensSubscription?.remove()
    this.needProvideTokensSubscription = emitter.addListener('needProvideTokens', async () => {
      const authTokens = await provideAuthTokens();
      nablaClientModule.provideTokens(
        authTokens.refreshToken,
        authTokens.accessToken,
      );
    });
  }

  /**
   * Set the log level for the sdk logs
   * @param level the minimum logs level for the logs that are sent to the logger
   */
  public setLogLevel(level: LogLevel) {
    logWatcherModule.setLogLevel(level);
  }

  private handleNativeLog(nativeLog: NativeLog) {
    let nablaError = nativeLog.error ? mapCoreError(nativeLog.error) : undefined;
    switch (nativeLog.level) {
      case 'debug':
        this.logger?.debug(nativeLog.tag, nativeLog.message, nablaError);
        break;
      case 'info':
        this.logger?.info(nativeLog.tag, nativeLog.message, nablaError);
        break;
      case 'warn':
        this.logger?.warn(nativeLog.tag, nativeLog.message, nablaError);
        break;
      case 'error':
        this.logger?.error(nativeLog.tag, nativeLog.message, nablaError);
        break;
    }
  }
}
