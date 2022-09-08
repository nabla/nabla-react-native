import { NativeModule, NativeModules, Platform } from 'react-native';
import { VideoCallRoom } from '../types';
import { Callback } from '@nabla/react-native-core/lib/internal'

const LINKING_ERROR =
  `The package '@nabla/react-native-video-call' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

interface NablaVideoCallClientModule extends NativeModule {
  initializeVideoCallModule(): Promise<void>;
  joinVideoCall(room: VideoCallRoom, callback: Callback<void>): void;
}

export const nablaVideoCallClientModule: NablaVideoCallClientModule =
  NativeModules.NablaVideoCallClientModule
    ? NativeModules.NablaVideoCallClientModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        },
      );
