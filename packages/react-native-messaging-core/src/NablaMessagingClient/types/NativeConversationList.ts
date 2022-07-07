import { mapConversation, NativeConversation } from './NativeConversation';
import { ConversationList } from '../../types';

export class NativeConversationList {
  conversations: NativeConversation[];
  hasMore: Boolean;

  constructor(conversations: NativeConversation[], hasMore: Boolean) {
    this.conversations = conversations;
    this.hasMore = hasMore;
  }
}

export const mapConversationList: (
  conversationList: NativeConversationList,
) => ConversationList = (conversationList) => {
  return new ConversationList(
    conversationList.conversations.map(mapConversation),
    conversationList.hasMore,
  );
};
