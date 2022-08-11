import {
  NativeSyntheticEvent,
  requireNativeComponent,
  ViewProps,
} from 'react-native';

import React from 'react';
import { ConversationId } from '@nabla/react-native-messaging-core';

export const NativeConversationListView = requireNativeComponent(
  'NablaConversationListView',
);

type NablaConversationListViewProps = ViewProps & {
  onConversationSelected: (conversationId: ConversationId) => void;
};

export const NablaConversationListView: React.FC<
  NablaConversationListViewProps
> = (props: NablaConversationListViewProps) => {
  const nativeProps = {
    ...props,
    onConversationSelected: (
      event: NativeSyntheticEvent<{ conversationId: ConversationId }>,
    ) => {
      props.onConversationSelected(event.nativeEvent.conversationId);
    },
  };
  return <NativeConversationListView {...nativeProps} />;
};
