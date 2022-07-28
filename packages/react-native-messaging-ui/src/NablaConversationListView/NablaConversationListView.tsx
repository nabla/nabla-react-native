import {
  NativeSyntheticEvent,
  requireNativeComponent,
  ViewProps,
} from 'react-native';

import React from 'react';

export const NativeConversationListView = requireNativeComponent(
  'NablaConversationListView',
);

type NablaConversationListViewProps = ViewProps & {
  onConversationSelected: (conversationId: string) => void;
};

export const NablaConversationListView: React.FC<
  NablaConversationListViewProps
> = (props: NablaConversationListViewProps) => {
  const nativeProps = {
    ...props,
    onConversationSelected: (
      event: NativeSyntheticEvent<{ conversationId: string }>,
    ) => {
      props.onConversationSelected(event.nativeEvent.conversationId);
    },
  };
  return <NativeConversationListView {...nativeProps} />;
};
