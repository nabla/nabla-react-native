import { nablaMessagingUIModule } from './NablaMessagingUIModule';
import { ConversationId } from '@nabla/react-native-messaging-core';
import { NablaError } from '@nabla/react-native-core';
import { merge } from '@nabla/react-native-core/lib/internal';
import { mapError } from '@nabla/react-native-messaging-core/lib/internal';

/**
 * Main entry-point for Messaging UI features.
 *
 * Mandatory: before any interaction with messaging features make sure you
 * successfully authenticated your user by calling `NablaClient.getInstance().authenticate`.
 */
export class NablaMessagingUI {
  /**
   * Launches the Inbox Screen.
   */
  public static navigateToInbox() {
    nablaMessagingUIModule.navigateToInbox();
  }

  /**
   * Launches the Conversation Screen.
   * @param conversationId the id of the conversation to display.
   * @param showComposer optional flag to show or hide the composer.
   * @param errorCallback optional callback called in case of error. (Bad conversationId)
   * @param successCallback optional callback called when navigation succeeds.
   */
  public static navigateToConversation(
    conversationId: ConversationId,
    showComposer: boolean = true,
    errorCallback: (error: NablaError) => void = () => {},
    successCallback: () => void = () => {},
  ) {
    nablaMessagingUIModule.navigateToConversation(
      conversationId,
      showComposer,
      merge(
        mapError,
        errorCallback,
        successCallback,
      ));
  }
}
