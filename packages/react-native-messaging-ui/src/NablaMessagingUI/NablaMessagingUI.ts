import { nablaMessagingUIModule } from './NablaMessagingUIModule';

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
    conversationId: string,
    showComposer: boolean = true,
  ) {
    nablaMessagingUIModule.navigateToConversation(conversationId, showComposer);
  }
}
