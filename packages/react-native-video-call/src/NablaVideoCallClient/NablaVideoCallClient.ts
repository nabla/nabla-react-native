import { nablaVideoCallClientModule } from './NablaVideoCallClientModule';
import { VideoCallRoom } from '../types';
import { NablaError } from '@nabla/react-native-core'
import { merge, mapCoreError } from '@nabla/react-native-core/lib/internal'

/**
 * Main entry-point to SDK-wide features.
 */
export class NablaVideoCallClient {

  /**
   * Initializes the VideoCall module and register it on `NablaClient`
   * Must be called before `NablaClient.getInstance().initialize()`
   */
  public static async initializeVideoCallModule() {
    await nablaVideoCallClientModule.initializeVideoCallModule();
  }

  /**
   * Join a video call room.
   * @param room the `VideoCallRoom` to join.
   * @param errorCallback The callback called in case of error.
   * @param successCallback The callback called when joined successfully.
   */
  public static joinVideoCallRoom(room: VideoCallRoom,
                                  errorCallback: (error: NablaError) => void,
                                  successCallback: () => void) {
    nablaVideoCallClientModule.joinVideoCall(
      room,
      merge(mapCoreError, errorCallback, successCallback)
    );
  }
}
