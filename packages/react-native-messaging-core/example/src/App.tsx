import type {
  Conversation,
  ConversationList,
  NablaError,
} from '@nabla/react-native-messaging-core'
import {
  AuthTokens,
  NablaAuthenticationError,
  NablaClient,
  NablaMessagingClient,
} from '@nabla/react-native-messaging-core'
import * as React from 'react'
import { useState } from 'react'
import {
  Button,
  FlatList,
  ListRenderItem,
  SafeAreaView,
  Text,
  TouchableHighlight,
  View,
} from 'react-native'

const delay = (ms: number) => new Promise((res) => setTimeout(res, ms))

const ConversationCell: React.FC<Conversation> = (conversation) => {
  return (
    <View style={{ padding: 20 }}>
      <Text>{conversation.inboxPreviewTitle}</Text>
      <Text>{conversation.lastMessagePreview}</Text>
      <Text>Last modified: {conversation.lastModified.toDateString()}</Text>
    </View>
  )
}

export default function App() {
  let [conversationList, setConversationList] = useState<
    ConversationList | undefined
  >(undefined)
  let [watchConversationsError, setWatchConversationsError] = useState<
    NablaError | undefined
  >(undefined)

  const nablaClient = NablaClient.getInstance()

  const initialize = () => {
    nablaClient.initialize('apiKey')
  }

  const authenticate = () => {
    nablaClient.authenticate('userId', async () => {
      await delay(1000)
      return new AuthTokens('refreshToken', 'accessToken')
    })
  }

  const nablaMessagingClient = NablaMessagingClient.getInstance()
  const watchConversations = () => {
    const subscription = nablaMessagingClient.watchConversations(
      (error) => {
        switch (error.type) {
          case NablaAuthenticationError.MissingAuthenticationProvider:
            console.log('Please authenticate')
        }
        setWatchConversationsError(error)
        setConversationList(undefined)
        subscription.remove()
      },
      (list: ConversationList) => {
        setWatchConversationsError(undefined)
        setConversationList(list)
      }
    )
  }

  const loadMoreConversations = () => {
    nablaMessagingClient.loadMoreConversations(
      (error: NablaError) => {
        console.log(error)
      },
      () => {
        console.log('loadMoreSuccess')
      }
    )
  }

  const createConversation = () => {
    nablaMessagingClient.createConversation(
      (error) => {
        console.log(error)
      },
      (conversationId) => {
        console.log(`createConversationSuccess id: ${conversationId}`)
      }
    )
  }

  const renderConversation: ListRenderItem<Conversation> = ({ item }) => (
    <TouchableHighlight>
      <ConversationCell {...item} />
    </TouchableHighlight>
  )

  let loadMoreConversationsButton
  if (conversationList?.hasMore) {
    loadMoreConversationsButton = (
      <Button title='Load More Conversations' onPress={loadMoreConversations} />
    )
  }

  let watchConversationsErrorDescription
  if (watchConversationsError) {
    watchConversationsErrorDescription = (
      <View>
        <Text> - Type: {watchConversationsError.type}</Text>
        <Text style={{ marginBottom: 20 }}>
          {' '}
          - Message: {watchConversationsError.message}
        </Text>
        <Button title='Retry Watch Conversation' onPress={watchConversations} />
      </View>
    )
  }

  const data = conversationList?.conversations.sort((a, b) => {
    return (
      new Date(b.lastModified).getTime() - new Date(a.lastModified).getTime()
    )
  })

  return (
    <SafeAreaView>
      <Button title='Initialize' onPress={initialize} />
      <Button title='Authenticate' onPress={authenticate} />
      <Button title='Watch Conversations' onPress={watchConversations} />
      <Button title='Create Conversation' onPress={createConversation} />
      <View style={{ height: 20, backgroundColor: 'white' }} />
      {watchConversationsErrorDescription}
      <FlatList
        data={data}
        renderItem={renderConversation}
        keyExtractor={(conversation) => conversation.id}
      />
      {loadMoreConversationsButton}
    </SafeAreaView>
  )
}
