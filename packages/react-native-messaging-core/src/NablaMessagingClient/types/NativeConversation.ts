import { Conversation, ConversationId } from '../../types';
import {
  mapProviderInConversation,
  NativeProviderInConversation,
} from './NativeProviderInConversation';

export interface NativeConversation {
  id: ConversationId;
  title?: string;
  inboxPreviewTitle: string;
  lastMessagePreview?: string;
  lastModified: string;
  patientUnreadMessageCount: number;
  providers: NativeProviderInConversation[];
}

export const mapConversation: (
  conversation: NativeConversation,
) => Conversation = (conversation) => {
  return new Conversation(
    conversation.id,
    conversation.inboxPreviewTitle,
    new Date(conversation.lastModified),
    conversation.patientUnreadMessageCount,
    conversation.providers.map(mapProviderInConversation),
    conversation.title,
    conversation.lastMessagePreview,
  );
};
