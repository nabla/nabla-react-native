import React, { useEffect, useRef } from 'react';
import {
  findNodeHandle, NativeSyntheticEvent,
  Platform,
  StyleSheet,
  UIManager,
  ViewProps
} from "react-native";
import { NablaAppointmentListViewManager } from './NablaAppointmentListViewManager';
import { AppointmentId } from '../types';

const createFragment = (viewId: number | null) =>
  UIManager.dispatchViewManagerCommand(
    viewId,
    // we are calling the 'create' command
    // @ts-ignore
    UIManager.NablaAppointmentListView.Commands.create.toString(),
    [viewId],
  );

type NablaAppointmentListViewProps = ViewProps & {
  onAppointmentSelected: (appointmentId: AppointmentId) => void;
};

export const NablaAppointmentListView: React.FC<
  NablaAppointmentListViewProps
> = (props: NablaAppointmentListViewProps) => {
  const ref = useRef(null);

  useEffect(() => {
    setTimeout( () => {
      if (Platform.OS === 'android') {
        const viewId = findNodeHandle(ref.current);
        createFragment(viewId);
      }
    })
  }, []);

  const nativeProps = {
    ...props,
    onAppointmentSelected: (
      event: NativeSyntheticEvent<{ appointmentId: AppointmentId }>,
    ) => {
      props.onAppointmentSelected(event.nativeEvent.appointmentId);
    },
  };

  return (
    <NablaAppointmentListViewManager
      style={styles.container}
      ref={ref}
      {...nativeProps}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
