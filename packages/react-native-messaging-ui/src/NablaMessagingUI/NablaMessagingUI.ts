import { nablaMessagingUIModule } from './NablaMessagingUIModule';
import { ConversationId } from '@nabla/react-native-messaging-core';

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
   */
  public static navigateToConversation(
    conversationId: ConversationId,
    showComposer: boolean = true,
  ) {
    nablaMessagingUIModule.navigateToConversation(conversationId, showComposer);
  }
}
