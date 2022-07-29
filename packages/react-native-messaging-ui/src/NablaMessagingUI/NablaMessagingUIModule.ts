import { NativeModule, NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-ui' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaMessagingUIModule extends NativeModule {
  navigateToConversation(conversationId: string, showComposer: boolean): void;
}

export const nablaMessagingUIModule: NablaMessagingUIModule =
  NativeModules.NablaMessagingUIModule
    ? NativeModules.NablaMessagingUIModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
