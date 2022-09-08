import { NativeModule, NativeModules, Platform } from 'react-native';
import { ConversationId, MessageId } from '../../types';
import { Callback } from '@nabla/react-native-core/lib/internal';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaMessagingClientModule extends NativeModule {
  initializeMessagingModule(): Promise<void>;

  createConversation(
    title: String | undefined,
    providerIds: String[] | undefined,
    callback: Callback<ConversationId>,
  ): void;

  sendMessage(
    input: any,
    conversationId: ConversationId,
    replyTo: MessageId | undefined,
    callback: Callback<void>,
  ): void;

  deleteMessage(
    messageId: MessageId,
    conversationId: ConversationId,
    callback: Callback<void>,
  ): void;

  markConversationAsSeen(
    conversationId: ConversationId,
    callback: Callback<void>,
  ): void;

  setIsTyping(
    isTyping: boolean,
    conversationId: ConversationId,
    callback: Callback<void>,
  ): void;
}

export const nablaMessagingClientModule: NablaMessagingClientModule =
  NativeModules.NablaMessagingClientModule
    ? NativeModules.NablaMessagingClientModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
