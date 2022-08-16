import { ConversationItem } from './ConversationItem';

export class ConversationItems {
  hasMore: boolean;
  items: ConversationItem[];

  constructor(hasMore: boolean, items: ConversationItem[]) {
    this.hasMore = hasMore;
    this.items = items;
  }
}
