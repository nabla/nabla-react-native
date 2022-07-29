import { nablaMessagingUIModule } from './NablaMessagingUIModule';

export class NablaMessagingUI {
  public static navigateToInbox() {
    nablaMessagingUIModule.navigateToInbox();
  }

  public static navigateToConversation(
    conversationId: string,
    showComposer: boolean = true,
  ) {
    nablaMessagingUIModule.navigateToConversation(conversationId, showComposer);
  }
}
