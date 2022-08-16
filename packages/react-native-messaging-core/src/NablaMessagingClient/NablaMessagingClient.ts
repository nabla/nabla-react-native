import { NativeEventEmitter } from 'react-native';
import equal from 'fast-deep-equal/es6';
import { NablaError } from '@nabla/react-native-core';
import { NativeError } from '@nabla/react-native-core/lib/internal';
import {
  Callback,
  conversationItemsWatcherModule,
  conversationListWatcherModule,
  conversationWatcherModule,
  nablaMessagingClientModule,
} from './NativeModules';
import {
  Conversation,
  ConversationId,
  ConversationItems,
  ConversationList,
  MessageId,
  MessageInput,
  NablaEventSubscription,
} from '../types';
import {
  mapConversation,
  mapConversationItems,
  mapConversationList,
  mapError,
  NativeConversation,
  NativeConversationItems,
  NativeConversationList,
} from './types';

const conversationListEmitter = new NativeEventEmitter(
  conversationListWatcherModule,
);
const conversationItemsEmitter = new NativeEventEmitter(
  conversationItemsWatcherModule,
);
const conversationEmitter = new NativeEventEmitter(conversationWatcherModule);

function merge<T>(
  errorCallback: (error: NablaError) => void,
  successCallback: (result: T) => void,
): Callback<T> {
  return (error, result) => {
    if (error) {
      errorCallback(mapError(error));
    } else if (result) {
      successCallback(result);
    }
  };
}

/**
 * Main entry-point for Messaging SDK features.
 *
 * Mandatory: before any interaction with messaging features make sure you
 * successfully authenticated your user by calling `NablaClient.getInstance().authenticate`.
 */
export class NablaMessagingClient {
  private static instance: NablaMessagingClient;

  private constructor() {
  }

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
  ): NablaEventSubscription {
    return new NablaEventSubscription(
      conversationListEmitter.addListener(
        'watchConversationsError',
        (error: NativeError) => {
          errorCallback(mapError(error));
        },
      ),
      conversationListEmitter.addListener(
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
    conversationListWatcherModule.loadMoreConversations(merge(errorCallback, successCallback));
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
    successCallback: (conversationId: ConversationId) => void,
    title?: string,
    providerIds?: string[],
  ) {
    nablaMessagingClientModule.createConversation(
      title,
      providerIds,
      merge(errorCallback, successCallback),
    );
  }

  /**
   * Watch the conversation referenced by its identifier.
   * @param conversationId The id of the `Conversation`.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when the conversation is updated.
   */
  public async watchConversation(
    conversationId: ConversationId,
    errorCallback: (error: NablaError) => void,
    successCallback: (conversation: Conversation) => void,
  ): Promise<NablaEventSubscription> {
    return new Promise((resolve, reject) => {
      const subscription = new NablaEventSubscription(
        conversationEmitter.addListener(
          'watchConversationError',
          (error: NativeError & { id: ConversationId }) => {
            if (error.id === conversationId) {
              errorCallback(mapError(error));
            }
          },
        ),
        conversationEmitter.addListener(
          'watchConversationUpdated',
          (data: NativeConversation) => {
            if (equal(data.id, conversationId)) {
              successCallback(mapConversation(data));
            }
          },
        ),
        () => {
          conversationWatcherModule.unsubscribeFromConversation(conversationId);
        },
      );
      conversationWatcherModule.watchConversation(conversationId, (error) => {
        if (error) {
          subscription.remove();
          reject(mapError(error));
        } else {
          resolve(subscription);
        }
      });
    });
  }

  /**
   * Watch the list of items in the conversation referenced by its identifier.
   * @param conversationId The id of the `Conversation`.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when new items are received.
   */
  public async watchItemsOfConversation(
    conversationId: ConversationId,
    errorCallback: (error: NablaError) => void,
    successCallback: (conversationItems: ConversationItems) => void,
  ): Promise<NablaEventSubscription> {
    return new Promise((resolve, reject) => {
      const subscription = new NablaEventSubscription(
        conversationItemsEmitter.addListener(
          'watchConversationItemsError',
          (error: NativeError & { id: ConversationId }) => {
            if (equal(error.id, conversationId)) {
              errorCallback(mapError(error));
            }
          },
        ),
        conversationItemsEmitter.addListener(
          'watchConversationItemsUpdated',
          (data: NativeConversationItems) => {
            if (equal(data.id, conversationId)) {
              successCallback(mapConversationItems(data));
            }
          },
        ),
        () => {
          conversationItemsWatcherModule.unsubscribeFromConversationItems(
            conversationId,
          );
        },
      );
      conversationItemsWatcherModule.watchConversationItems(
        conversationId,
        (error) => {
          if (error) {
            subscription.remove();
            reject(mapError(error));
          } else {
            resolve(subscription);
          }
        },
      );
    });
  }

  /**
   * Load more items in the conversation.
   * Needs to be called with active subscription from `watchItemsOfConversation`.
   * @param conversationId The id of the `Conversation`.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when loading succeeds.
   */
  public loadMoreItemsInConversation(
    conversationId: ConversationId,
    errorCallback: (error: NablaError) => void,
    successCallback: () => void,
  ) {
    conversationItemsWatcherModule.loadMoreItemsInConversation(
      conversationId,
      merge(errorCallback, successCallback),
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
    conversationId: ConversationId,
    replyTo?: MessageId,
  ) {
    nablaMessagingClientModule.sendMessage(
      input.serialize(),
      conversationId,
      replyTo,
      merge(errorCallback, successCallback),
    );
  }

  /**
   * Delete a message in the conversation referenced by its identifier.
   * @param messageId The id of the `Message`.
   * @param conversationId The id of the `Conversation`.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when message deletion succeeds.
   */
  public deleteMessage(
    messageId: MessageId,
    conversationId: ConversationId,
    errorCallback: (error: NablaError) => void,
    successCallback: () => void,
  ) {
    nablaMessagingClientModule.deleteMessage(
      messageId,
      conversationId,
      merge(errorCallback, successCallback)
    );
  }

  /**
   * Notify the server that the patient has seen the conversation.
   * @param conversationId The id of the `Conversation`.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when call succeeds.
   */
  public markConversationAsSeen(
    conversationId: ConversationId,
    errorCallback: (error: NablaError) => void,
    successCallback: () => void,
  ) {
    nablaMessagingClientModule.markConversationAsSeen(
      conversationId,
      merge(errorCallback, successCallback),
    );
  }

  /**
   * Notify the server that the patient is typing in the conversation.
   * @param isTyping Whether the patient is typing.
   * @param conversationId The id of the `Conversation`.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when call succeeds.
   */
  public setIsTyping(
    isTyping: boolean,
    conversationId: ConversationId,
    errorCallback: (error: NablaError) => void,
    successCallback: () => void,
  ) {
    nablaMessagingClientModule.setIsTyping(
      isTyping,
      conversationId,
      merge(errorCallback, successCallback),
    );
  }
}
