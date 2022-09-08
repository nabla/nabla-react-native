import { NativeModule, NativeModules, Platform } from 'react-native';
import { ConversationId } from '../../types';
import { Callback } from '@nabla/react-native-core/lib/internal';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface ConversationItemsWatcherModule extends NativeModule {
  watchConversationItems(
    conversationId: ConversationId,
    callback: Callback<void>,
  ): void;

  loadMoreItemsInConversation(
    conversationId: ConversationId,
    callback: Callback<void>,
  ): void;

  unsubscribeFromConversationItems(conversationId: ConversationId): void;
}

export const conversationItemsWatcherModule: ConversationItemsWatcherModule =
  NativeModules.ConversationItemsWatcherModule
    ? NativeModules.ConversationItemsWatcherModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
