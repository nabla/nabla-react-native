import { NativeModule, NativeModules, Platform } from 'react-native';
import { NativeError } from '@nabla/react-native-core/lib/internal';
import { ConversationId } from '../../types';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface ConversationWatcherModule extends NativeModule {
  watchConversation(
    conversationId: ConversationId,
    callback: (error: NativeError | undefined) => void,
  ): void;

  unsubscribeFromConversation(conversationId: ConversationId): void;
}

export const conversationWatcherModule: ConversationWatcherModule =
  NativeModules.ConversationWatcherModule
    ? NativeModules.ConversationWatcherModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
