import { NativeModule, NativeModules, Platform } from 'react-native';
import { Callback } from '@nabla/react-native-core/lib/internal';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface ConversationListWatcherModule extends NativeModule {
  loadMoreConversations(callback: Callback<void>): void;
}

export const conversationListWatcherModule: ConversationListWatcherModule =
  NativeModules.ConversationListWatcherModule
    ? NativeModules.ConversationListWatcherModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
