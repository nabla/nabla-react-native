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

import { authenticateUser } from './authenticateUser';
import { ConversationCell } from './ConversationCell';
import { nablaMessagingClient, nablaMessagingUIClient } from './nablaClients';
import { NablaConversationListView } from '@nabla/react-native-messaging-ui';

enum HomeState {
  NONE,
  AUTHENTICATED,
  DISPLAY_NATIVE_CONVERSATION_LIST,
  WATCH_MANUALLY,
}

export default function App() {
  const [homeState, setHomeState] = useState(HomeState.NONE);
  const [conversationList, setConversationList] = useState<ConversationList>();
  const [watchConversationsError, setWatchConversationsError] =
    useState<NablaError>();

  const authenticate = () => {
    authenticateUser();
    setHomeState(HomeState.AUTHENTICATED);
  };

  const displayNativeConversationListView = () => {
    setHomeState(HomeState.DISPLAY_NATIVE_CONVERSATION_LIST);
  };

  const watchConversations = () => {
    setHomeState(HomeState.WATCH_MANUALLY);
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
    console.log('navigateToConversation', conversationId);
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

  let createConversationButton = (
    <View style={styles.hEndContainer}>
      <Button title="Create Conversation" onPress={createConversation} />
    </View>
  );

  let contentView;
  switch (homeState) {
    case HomeState.NONE:
      contentView = (
        <SafeAreaView>
          <Button title="Authenticate" onPress={authenticate} />
        </SafeAreaView>
      );
      break;
    case HomeState.AUTHENTICATED:
      contentView = (
        <SafeAreaView style={{ flex: 1 }}>
          <View style={styles.hContainer}>
            <View style={{ flex: 1.5 }}>
              <Button
                title="Display Native ConversationsListView"
                onPress={displayNativeConversationListView}
              />
            </View>
            <View style={{ flex: 1 }}>
              <Button
                title="Watch Conversations"
                onPress={watchConversations}
              />
            </View>
          </View>
        </SafeAreaView>
      );
      break;
    case HomeState.DISPLAY_NATIVE_CONVERSATION_LIST:
      contentView = (
        <View style={styles.vContainer}>
          {createConversationButton}
          <NablaConversationListView
            onConversationSelected={(conversationId) => {
              nablaMessagingUIClient.navigateToConversation(conversationId);
            }}
            style={{ flex: 1 }}
          />
        </View>
      );
      break;
    case HomeState.WATCH_MANUALLY:
      contentView = (
        <View style={styles.vContainer}>
          {watchConversationsErrorDescription}
          {createConversationButton}
          <FlatList
            data={conversationList?.conversations}
            renderItem={renderConversation}
            keyExtractor={(conversation) => conversation.id}
          />
          {loadMoreConversationsButton}
        </View>
      );
      break;
  }

  return (
    <View style={styles.vContainer}>
      <SafeAreaView></SafeAreaView>
      <View style={styles.vContainer}>{contentView}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  buttonsContainer: {
    flex: 1,
  },
  hContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  hEndContainer: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
  },
  vContainer: {
    flex: 1,
  },
  separator: { height: 20, backgroundColor: 'white' },
  errorDescription: { marginBottom: 20 },
});
