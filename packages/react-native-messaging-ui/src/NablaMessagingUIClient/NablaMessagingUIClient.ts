import { nablaMessagingUIClientModule } from './NablaMessagingUIClientModule';

export class NablaMessagingUIClient {
  private static instance: NablaMessagingUIClient;

  private constructor() {}

  public static getInstance(): NablaMessagingUIClient {
    if (!NablaMessagingUIClient.instance) {
      NablaMessagingUIClient.instance = new NablaMessagingUIClient();
    }

    return NablaMessagingUIClient.instance;
  }

  public navigateToConversation(
    conversationId: string,
    showComposer: boolean = true,
  ) {
    nablaMessagingUIClientModule.navigateToConversation(
      conversationId,
      showComposer,
    );
  }
}
