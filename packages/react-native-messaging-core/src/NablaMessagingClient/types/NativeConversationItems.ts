import {
  mapConversationItem,
  NativeConversationItem,
} from './NativeConversationItem';
import { ConversationId, ConversationItems } from '../../types';

export interface NativeConversationItems {
  id: ConversationId;
  hasMore: boolean;
  items: NativeConversationItem[];
}

export const mapConversationItems: (
  conversationItems: NativeConversationItems,
) => ConversationItems = (conversationItems) => {
  return new ConversationItems(
    conversationItems.hasMore,
    conversationItems.items.map(mapConversationItem),
  );
};
