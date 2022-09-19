import React, { useEffect, useRef } from 'react';
import { findNodeHandle, Platform, StyleSheet, UIManager, View } from 'react-native';
import { NablaAppointmentListViewManager } from './NablaAppointmentListViewManager';

const createFragment = (viewId: number | null) =>
  UIManager.dispatchViewManagerCommand(
    viewId,
    // we are calling the 'create' command
    // @ts-ignore
    UIManager.NablaAppointmentListView.Commands.create.toString(),
    [viewId],
  );


export const NablaAppointmentListView: React.FC = () => {
  const ref = useRef(null);

  useEffect(() => {

    if (Platform.OS === 'android') {
      const viewId = findNodeHandle(ref.current);
      createFragment(viewId);
    }
  }, []);

  return (
    <NablaAppointmentListViewManager
      style={styles.container}
      ref={ref}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
