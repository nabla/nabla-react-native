import {
  mapConversationItem,
  NativeConversationItem,
} from './NativeConversationItem';
import { ConversationId, ConversationItem, PaginatedList } from '../../types';

export type NativeConversationItems = PaginatedList<NativeConversationItem> & {
  id: ConversationId;
};

export const mapConversationItems: (
  conversationItems: NativeConversationItems,
) => PaginatedList<ConversationItem> = (conversationItems) => ({
  hasMore: conversationItems.hasMore,
  elements: conversationItems.elements.map(mapConversationItem),
});
