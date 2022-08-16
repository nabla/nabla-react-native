import { NativeModule, NativeModules, Platform } from 'react-native';
import { ConversationId } from '../../types';
import { Callback } from './Callback';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface ConversationWatcherModule extends NativeModule {
  watchConversation(
    conversationId: ConversationId,
    callback: Callback<void>,
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
