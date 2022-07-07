import type { Conversation } from './Conversation';

export class ConversationList {
  conversations: Conversation[];
  hasMore: Boolean;

  constructor(conversations: Conversation[], hasMore: Boolean) {
    this.conversations = conversations;
    this.hasMore = hasMore;
  }
}
