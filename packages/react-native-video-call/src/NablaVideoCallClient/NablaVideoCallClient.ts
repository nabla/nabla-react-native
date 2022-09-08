import { nablaVideoCallClientModule } from './NablaVideoCallClientModule';
import { VideoCallRoom } from '../types';
import { NablaError } from '@nabla/react-native-core'
import { merge, mapCoreError } from '@nabla/react-native-core/lib/internal'

/**
 * Main entry-point to SDK-wide features.
 */
export class NablaVideoCallClient {
  public static async initializeVideoCallModule() {
    await nablaVideoCallClientModule.initializeVideoCallModule();
  }

  public static joinVideoCallRoom(room: VideoCallRoom,
                                  errorCallback: (error: NablaError) => void,
                                  successCallback: () => void) {
    nablaVideoCallClientModule.joinVideoCall(room, merge(mapCoreError, errorCallback, successCallback));
  }
}
