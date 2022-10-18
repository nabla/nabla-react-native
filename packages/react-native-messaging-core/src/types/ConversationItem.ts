import { MessageId, Provider } from './index';

export type MaybeProvider =
  | { type: 'DeletedProvider' }
  | { type: 'Provider'; provider: Provider };

export type ConversationActivity = {
  id: string;
  type: 'ConversationActivity';
  activity: {
    type: 'ProviderJoined';
    maybeProvider: MaybeProvider;
  };
};

export type VideoCallRoom = {
  id: string;
  token: string;
  url: string;
};

export type VideoCallRoomInteractiveMessage = {
  id: string;
  type: 'VideoCallRoomInteractiveMessage';
  sender: ConversationItemSender;
  videoCallRoomInteractiveMessage:
    | {
        status: 'closed';
      }
    | {
        status: 'open';
        room: VideoCallRoom;
      };
};

type DeletedMessageItemContent = {
  type: 'DeletedMessageItem';
};

type TextMessageItemContent = {
  type: 'TextMessageItem';
  text: string;
};

type MediaContent =
  | {
      type: 'url';
      fileURL: string;
    }
  | {
      type: 'base64Data';
      data: string;
    };

type Media = {
  fileName: string;
  mimeType: string;
  content: MediaContent;
};

type MediaSize = {
  width: number;
  height: number;
};

type ImageMessageItemContent = {
  type: 'ImageMessageItem';
  image: Media & {
    size: MediaSize | undefined;
  };
};

type VideoMessageItemContent = {
  type: 'VideoMessageItem';
  video: Media & {
    size: MediaSize | undefined;
  };
};

type AudioMessageItemContent = {
  type: 'AudioMessageItem';
  audio: Media & {
    durationMs: number | undefined;
  };
};

type DocumentMessageItemContent = {
  type: 'DocumentMessageItem';
  document: Media & { thumbnailURL: string };
};

type ConversationMessageContent =
  | DeletedMessageItemContent
  | TextMessageItemContent
  | ImageMessageItemContent
  | VideoMessageItemContent
  | AudioMessageItemContent
  | DocumentMessageItemContent;

export type ConversationItemSender =
  | { type: 'Patient' }
  | { type: 'Provider'; provider: Provider }
  | { type: 'System'; system: { name: string; avatarURL: string | undefined } }
  | { type: 'Deleted' }
  | { type: 'Unknown' };

export type ConversationMessage = {
  id: MessageId;
  type: 'ConversationMessage';
  sender: ConversationItemSender;
  sendingState: 'sent' | 'toBeSent' | 'sending' | 'failed';
  replyTo: ConversationMessage | undefined;
  content: ConversationMessageContent;
};

export type ConversationItem = { createdAt: Date } & (
  | ConversationActivity
  | ConversationMessage
  | VideoCallRoomInteractiveMessage
);
