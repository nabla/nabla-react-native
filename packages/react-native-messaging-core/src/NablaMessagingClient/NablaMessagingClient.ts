import { ConversationList } from '../types';
import { ConversationsEventSubscription } from './types/ConversationsEventSubscription';
import { MessageInput } from '../types';
import { NativeError } from '@nabla/react-native-core/lib/internal';
import { NativeEventEmitter } from 'react-native';
import { nablaMessagingClientModule } from './NablaMessagingClientModule';
import {
  mapConversationList,
  NativeConversationList,
} from './types/NativeConversationList';
import { NablaError } from '@nabla/react-native-core';
import { mapError } from './types/errorMapper';

const emitter = new NativeEventEmitter(nablaMessagingClientModule);

/**
 * Main entry-point for Messaging SDK features.
 *
 * Mandatory: before any interaction with messaging features make sure you
 * successfully authenticated your user by calling `NablaClient.getInstance().authenticate`.
 */
export class NablaMessagingClient {
  private static instance: NablaMessagingClient;

  private constructor() {}

  /**
   * Shared Instance to use for all interactions with the messaging SDK.
   */
  public static getInstance(): NablaMessagingClient {
    if (!NablaMessagingClient.instance) {
      NablaMessagingClient.instance = new NablaMessagingClient();
    }

    return NablaMessagingClient.instance;
  }

  /**
   * Watch the list of conversations the current user is involved in.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when new items are received.
   * @return A `ConversationsEventSubscription` to unsubscribe from the event.
   */
  public watchConversations(
    errorCallback: (error: NablaError) => void,
    successCallback: (conversationsList: ConversationList) => void,
  ): ConversationsEventSubscription {
    return new ConversationsEventSubscription(
      emitter.addListener('watchConversationsError', (error: NativeError) => {
        errorCallback(mapError(error));
      }),
      emitter.addListener(
        'watchConversationsUpdated',
        (data: NativeConversationList) => {
          successCallback(mapConversationList(data));
        },
      ),
    );
  }

  /**
   * Load more conversations.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when loading succeeds.
   */
  public loadMoreConversations(
    errorCallback: (error: NablaError) => void,
    successCallback: () => void,
  ): void {
    nablaMessagingClientModule.loadMoreConversations((error) => {
      if (error) {
        errorCallback(mapError(error));
      } else {
        successCallback();
      }
    });
  }

  /**
   * Create a new conversation on behalf of the current user.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when conversation creation succeeds.
   * @param title optional title for the conversation.
   * @param providerIds optional providers ids list that will participate in the conversation. Make sure the specified providers have enough rights to participate in a conversation. See [Roles and Permissions](https://docs.nabla.com/docs/roles-and-permissions).
   */
  public createConversation(
    errorCallback: (error: NablaError) => void,
    successCallback: (conversationId: string) => void,
    title?: string,
    providerIds?: string[],
  ) {
    nablaMessagingClientModule.createConversation(
      title,
      providerIds,
      (error, conversationId) => {
        if (error) {
          errorCallback(mapError(error));
        } else if (conversationId) {
          successCallback(conversationId);
        }
      },
    );
  }

  /**
   * Send a new message in the conversation referenced by its identifier.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when message sending succeeds.
   * @param input The `MessageInput` to send.
   * @param conversationId The id of the `Conversation`.
   * @param replyTo optional id of the message to reply to.
   */
  public sendMessage(
    errorCallback: (error: NablaError) => void,
    successCallback: () => void,
    input: MessageInput,
    conversationId: string,
    replyTo?: string,
  ) {
    nablaMessagingClientModule.sendMessage(
      input.serialize(),
      conversationId,
      replyTo,
      (error) => {
        if (error) {
          errorCallback(mapError(error));
        } else {
          successCallback();
        }
      },
    );
  }
}
