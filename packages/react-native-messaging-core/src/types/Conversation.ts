import { ProviderInConversation } from './ProviderInConversation';

export class Conversation {
  id: string;
  title?: string;
  inboxPreviewTitle: string;
  lastMessagePreview?: string;
  lastModified: Date;
  patientUnreadMessageCount: number;
  providers: ProviderInConversation[];

  constructor(
    id: string,
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
