import { NativeModule, NativeModules, Platform } from 'react-native';
import { Callback } from '@nabla/react-native-core/lib/internal';

const LINKING_ERROR =
  `The package '@nabla/react-native-scheduling' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaSchedulingUIModule extends NativeModule {
  navigateToScheduleAppointmentScreen(): void;
  navigateToAppointmentDetailScreen(
    appoinmentId: string,
    callbacl: Callback<void>): void;
}

export const nablaSchedulingUIModule: NablaSchedulingUIModule =
  NativeModules.NablaSchedulingUIModule
    ? NativeModules.NablaSchedulingUIModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
