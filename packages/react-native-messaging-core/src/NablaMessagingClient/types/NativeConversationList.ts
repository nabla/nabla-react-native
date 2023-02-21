import { mapConversation, NativeConversation } from './NativeConversation';
import { Conversation, PaginatedList } from '../../types';

export type NativeConversationList = PaginatedList<NativeConversation>;

export const mapConversationList: (
  conversationList: NativeConversationList,
) => PaginatedList<Conversation> = (conversationList) => ({
  elements: conversationList.elements.map(mapConversation),
  hasMore: conversationList.hasMore,
});
