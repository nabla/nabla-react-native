import { ProviderInConversation } from './ProviderInConversation';
import { ConversationId } from './ConversationId';

export class Conversation {
  id: ConversationId;
  title?: string;
  inboxPreviewTitle: string;
  lastMessagePreview?: string;
  lastModified: Date;
  patientUnreadMessageCount: number;
  providers: ProviderInConversation[];

  constructor(
    id: ConversationId,
    inboxPreviewTitle: string,
    lastModified: Date,
    patientUnreadMessageCount: number,
    providers: ProviderInConversation[],
    title?: string,
    lastMessagePreview?: string,
  ) {
    this.id = id;
    this.title = title;
    this.inboxPreviewTitle = inboxPreviewTitle;
    this.lastMessagePreview = lastMessagePreview;
    this.lastModified = lastModified;
    this.patientUnreadMessageCount = patientUnreadMessageCount;
    this.providers = providers;
  }
}
