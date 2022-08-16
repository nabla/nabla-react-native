import {
  ConversationActivity,
  ConversationItem,
  ConversationMessage,
} from '../../types';

export type NativeConversationItem = {
  createdAt: string;
} & (ConversationActivity | ConversationMessage);

// @ts-ignore
export const mapConversationItem: (
  conversationItem: NativeConversationItem,
) => ConversationItem = (conversationItem) => {
  const item = { ...conversationItem };
  // @ts-ignore
  item.createdAt = new Date(conversationItem.createdAt);
  return item;
};
