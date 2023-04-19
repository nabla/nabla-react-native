import { ProviderInConversation } from './ProviderInConversation';
import { ConversationId } from './ConversationId';
import { ConversationMessage } from "./ConversationItem";

export class Conversation {
  id: ConversationId;
  title?: string;
  inboxPreviewTitle: string;
  lastMessagePreview?: string;
  lastModified: Date;
  patientUnreadMessageCount: number;
  pictureURL?: string;
  providers: ProviderInConversation[];
  isLocked: boolean;
  lastMessage?: ConversationMessage;

  constructor(
    id: ConversationId,
    inboxPreviewTitle: string,
    lastModified: Date,
    patientUnreadMessageCount: number,
    providers: ProviderInConversation[],
    isLocked: boolean,
    title?: string,
    lastMessagePreview?: string,
    pictureURL?: string,
    lastMessage?: ConversationMessage,
  ) {
    this.id = id;
    this.title = title;
    this.inboxPreviewTitle = inboxPreviewTitle;
    this.lastMessagePreview = lastMessagePreview;
    this.lastModified = lastModified;
    this.patientUnreadMessageCount = patientUnreadMessageCount;
    this.pictureURL = pictureURL;
    this.providers = providers;
    this.isLocked = isLocked;
    this.lastMessage = lastMessage;
  }
}
