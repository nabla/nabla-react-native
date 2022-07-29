import { nablaMessagingUIModule } from './NablaMessagingUIModule';

export class NablaMessagingUI {
  public static navigateToConversation(
    conversationId: string,
    showComposer: boolean = true,
  ) {
    nablaMessagingUIModule.navigateToConversation(conversationId, showComposer);
  }
}
