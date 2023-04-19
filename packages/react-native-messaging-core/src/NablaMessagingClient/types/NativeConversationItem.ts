import {
  ConversationActivity,
  ConversationItem,
  ConversationMessage,
  ConversationItemSender,
  MaybeProvider,
  ConversationMessageContent,
  MessageId,
  VideoCallRoom,
  VideoCallRoomInteractiveMessage,
} from '../../types';

export type NativeConversationItem =
  | NativeConversationActivity
  | NativeConversationMessage
  | NativeVideoCallRoomInteractiveMessage;

export type NativeConversationActivity = {
  id: string;
  type: 'ConversationActivity';
  createdAt: string;
  activity: {
    type: 'ProviderJoined';
    maybeProvider: MaybeProvider;
  };
};

export type NativeConversationMessage = {
  id: MessageId;
  type: 'ConversationMessage';
  createdAt: string;
  sender: ConversationItemSender;
  sendingState: 'sent' | 'toBeSent' | 'sending' | 'failed';
  replyTo: NativeConversationMessage | undefined;
  content: ConversationMessageContent;
};

export type NativeVideoCallRoomInteractiveMessage = {
  id: string;
  type: 'VideoCallRoomInteractiveMessage';
  createdAt: string;
  sender: ConversationItemSender;
  videoCallRoomInteractiveMessage:
    | {
        status: 'closed';
      }
    | {
        room: VideoCallRoom;
        status: 'open';
      };
};

export const mapToConversationMessage: (
  conversationMessage: NativeConversationMessage,
) => ConversationMessage = (nativeMessage) => {
  return {
    ...nativeMessage,
    createdAt: new Date(nativeMessage.createdAt),
    replyTo: nativeMessage.replyTo
      ? mapToConversationMessage(nativeMessage.replyTo)
      : undefined,
  };
};

const mapToConversationActivity: (
  conversationMessage: NativeConversationActivity,
) => ConversationActivity = (nativeMessage) => {
  return {
    ...nativeMessage,
    createdAt: new Date(nativeMessage.createdAt),
  };
};

const mapToVideoCallRoomInteractiveMessage: (
  conversationMessage: NativeVideoCallRoomInteractiveMessage,
) => VideoCallRoomInteractiveMessage = (nativeMessage) => {
  return {
    ...nativeMessage,
    createdAt: new Date(nativeMessage.createdAt),
  };
};

export const mapConversationItem: (
  conversationItem: NativeConversationItem,
) => ConversationItem = (conversationItem) => {
  switch (conversationItem.type) {
    case 'ConversationActivity':
      return mapToConversationActivity(conversationItem);
    case 'ConversationMessage':
      return mapToConversationMessage(conversationItem);
    case 'VideoCallRoomInteractiveMessage':
      return mapToVideoCallRoomInteractiveMessage(conversationItem);
  }
};
