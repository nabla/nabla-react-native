import { Conversation, ConversationId } from '../../types';
import {
  mapProviderInConversation,
  NativeProviderInConversation,
} from './NativeProviderInConversation';
import {
  mapToConversationMessage,
  NativeConversationMessage,
} from './NativeConversationItem';

export interface NativeConversation {
  id: ConversationId;
  title?: string;
  inboxPreviewTitle: string;
  lastMessagePreview?: string;
  lastModified: string;
  patientUnreadMessageCount: number;
  providers: NativeProviderInConversation[];
  isLocked: boolean;
  pictureURL?: string;
  lastMessage?: NativeConversationMessage;
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
    conversation.isLocked,
    conversation.title,
    conversation.lastMessagePreview,
    conversation.pictureURL,
    conversation.lastMessage
      ? mapToConversationMessage(conversation.lastMessage)
      : undefined,
  );
};
