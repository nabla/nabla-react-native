import {
  findNodeHandle,
  Platform,
  requireNativeComponent, StyleSheet, UIManager,
  ViewProps,
} from 'react-native';

import React, { useEffect, useRef } from 'react';
import { ConversationId } from '@nabla/react-native-messaging-core';

export const NativeConversationView = requireNativeComponent<ViewProps>(
  'NablaConversationView',
);

type NablaConversationViewProps = ViewProps & {
  conversationId: ConversationId
};

const createFragment = (viewId: number | null) =>
  UIManager.dispatchViewManagerCommand(
    viewId,
    // we are calling the 'create' command
    // @ts-ignore
    UIManager.NablaConversationView.Commands.create.toString(),
    [viewId],
  );

export const NablaConversationView: React.FC<NablaConversationViewProps> = (props: NablaConversationViewProps) => {
  const ref = useRef(null);

  useEffect(() => {

    if (Platform.OS === 'android') {
      const viewId = findNodeHandle(ref.current);
      createFragment(viewId);
    }
  }, []);

  return (
    <NativeConversationView
      style={styles.container}
      ref={ref}
      {...props}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
