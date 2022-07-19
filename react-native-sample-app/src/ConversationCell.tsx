import { Conversation } from '@nabla/react-native-messaging-core';
import { Text, View } from 'react-native';
import * as React from 'react';

export const ConversationCell = ({
  conversation,
}: {
  conversation: Conversation;
}) => {
  return (
    <View style={{ padding: 20 }}>
      <Text>{conversation.inboxPreviewTitle}</Text>
      <Text>{conversation.lastMessagePreview}</Text>
      <Text>Last modified: {conversation.lastModified.toDateString()}</Text>
    </View>
  );
};
