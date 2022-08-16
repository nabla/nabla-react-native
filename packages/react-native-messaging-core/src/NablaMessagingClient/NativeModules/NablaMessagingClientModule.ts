import { NativeModule, NativeModules, Platform } from 'react-native';
import { NativeError } from '@nabla/react-native-core/lib/internal';
import { ConversationId, MessageId } from '../../types';

const LINKING_ERROR =
  `The package '@nabla/react-native-messaging-core' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaMessagingClientModule extends NativeModule {
  createConversation(
    title: String | undefined,
    providerIds: String[] | undefined,
    callback: (
      error: NativeError | undefined,
      conversationId: ConversationId | undefined,
    ) => void,
  ): void;

  sendMessage(
    input: any,
    conversationId: ConversationId,
    replyTo: MessageId | undefined,
    callback: (error: NativeError | undefined) => void,
  ): void;

  deleteMessage(
    messageId: MessageId,
    conversationId: ConversationId,
    callback: (error: NativeError | undefined) => void,
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