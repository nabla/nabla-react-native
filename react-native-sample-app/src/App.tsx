import type {
  Conversation,
  ConversationList,
  NablaError,
} from '@nabla/react-native-messaging-core';
import { NablaAuthenticationError } from '@nabla/react-native-messaging-core';
import * as React from 'react';
import { useState } from 'react';
import {
  Button,
  FlatList,
  ListRenderItem,
  SafeAreaView,
  StyleSheet,
  Text,
  TouchableHighlight,
  View,
} from 'react-native';

import { authenticate } from './authenticate';
import { ConversationCell } from './ConversationCell';
import { nablaMessagingClient, nablaMessagingUIClient } from './nablaClients';

export default function App() {
  const [conversationList, setConversationList] = useState<ConversationList>();
  const [watchConversationsError, setWatchConversationsError] =
    useState<NablaError>();

  const watchConversations = () => {
    const subscription = nablaMessagingClient.watchConversations(
      (error) => {
        switch (error.type) {
          case NablaAuthenticationError.MissingAuthenticationProvider:
            console.log('Please authenticate');
        }
        setWatchConversationsError(error);
        setConversationList(undefined);
        subscription.remove();
      },
      (list: ConversationList) => {
        setWatchConversationsError(undefined);
        setConversationList(list);
      },
    );
  };

  const loadMoreConversations = () => {
    nablaMessagingClient.loadMoreConversations(
      (error: NablaError) => {
        console.log({ ...error });
      },
      () => {
        console.log('loadMoreSuccess');
      },
    );
  };

  const createConversation = () => {
    nablaMessagingClient.createConversation(
      (error) => {
        console.log({ ...error });
      },
      (conversationId) => {
        console.log(`createConversationSuccess id: ${conversationId}`);
      },
    );
  };

  const navigateToConversation = (conversationId: string) => () => {
    nablaMessagingUIClient.navigateToConversation(conversationId);
  };

  const renderConversation: ListRenderItem<Conversation> = ({ item }) => (
    <TouchableHighlight onPress={navigateToConversation(item.id)}>
      <ConversationCell conversation={item} />
    </TouchableHighlight>
  );

  let loadMoreConversationsButton;
  if (conversationList?.hasMore) {
    loadMoreConversationsButton = (
      <Button title="Load More Conversations" onPress={loadMoreConversations} />
    );
  }

  let watchConversationsErrorDescription;
  if (watchConversationsError) {
    watchConversationsErrorDescription = (
      <View>
        <Text> - Type: {watchConversationsError.type}</Text>
        <Text style={styles.separator}>
          {' '}
          - Message: {watchConversationsError.message}
        </Text>
        <Button title="Retry Watch Conversation" onPress={watchConversations} />
      </View>
    );
  }

  const data = conversationList?.conversations.sort((a, b) => {
    return (
      new Date(b.lastModified).getTime() - new Date(a.lastModified).getTime()
    );
  });

  return (
    <SafeAreaView>
      <Button title="Authenticate" onPress={authenticate} />
      <Button title="Watch Conversations" onPress={watchConversations} />
      <Button title="Create Conversation" onPress={createConversation} />
      <View style={styles.separator} />
      {watchConversationsErrorDescription}
      <FlatList
        data={data}
        renderItem={renderConversation}
        keyExtractor={(conversation) => conversation.id}
      />
      {loadMoreConversationsButton}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  separator: { height: 20, backgroundColor: 'white' },
  errorDescription: { marginBottom: 20 },
});
