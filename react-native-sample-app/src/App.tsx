import * as React from 'react';
import { Platform, StyleSheet, Text, View } from 'react-native';

import { Appbar } from 'react-native-paper';
import { NablaConversationListView } from '@nabla/react-native-messaging-ui';
import { NablaClient } from '@nabla/react-native-core';
import {
  AuthTokens,
  getStableId,
  NablaMessagingClient,
} from '@nabla/react-native-messaging-core';
import { NablaMessagingUI } from '@nabla/react-native-messaging-ui';

const apiKey = 'YOUR_API_KEY';
const accessToken = 'yourAccessToken';
const refreshToken = 'yourRefreshToken';

const nablaClient = NablaClient.getInstance();
nablaClient.initialize(apiKey);

const dummyUserId = 'f0faa561-5707-402e-b7b9-5b747995e1fe';
nablaClient.authenticate(dummyUserId, async () => {
  return new AuthTokens(refreshToken, accessToken);
});

const nablaMessagingClient = NablaMessagingClient.getInstance();

const createConversationIcon = () => (
  <Text style={styles.appbarButtonTextStyle}>+</Text>
);

export default function App() {
  const createConversation = () => {
    nablaMessagingClient.createConversation(
      (error) => {
        console.log({ ...error });
      },
      (conversationId) => {
        console.log(`createConversationSuccess id: ${getStableId(conversationId)}`);
      },
    );
  };

  return (
    <View style={styles.vContainer}>
      <View style={styles.vContainer}>
        <Appbar.Header style={styles.appbarHeaderStyle}>
          <Appbar.Content
            color={Platform.OS === 'ios' ? 'black' : 'white'}
            title='Medical chat'
          />
          <Appbar.Action
            icon={createConversationIcon}
            onPress={createConversation}
          />
        </Appbar.Header>
        <NablaConversationListView
          onConversationSelected={(conversationId) => {
            NablaMessagingUI.navigateToConversation(conversationId);
          }}
          style={styles.conversationListViewStyle}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  vContainer: {
    flex: 1,
  },
  conversationListViewStyle: {
    flex: 1,
  },
  appbarHeaderStyle: {
    backgroundColor: Platform.OS === 'ios' ? 'white' : '#6750a4',
  },
  appbarButtonTextStyle: {
    color: Platform.OS === 'ios' ? 'blue' : 'white',
    fontSize: 18,
    textAlign: 'center',
  },
});
