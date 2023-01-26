import { nablaSchedulingUIModule } from './NablaSchedulingUIModule';
import { AppointmentId } from "../types";
import { NablaError } from '@nabla/react-native-core';
import { mapError } from '@nabla/react-native-messaging-core/lib/internal';
import { mergeVoid } from '@nabla/react-native-core/lib/internal';

/**
 * Main entry-point for Scheduling UI features.
 *
 * Mandatory: before any interaction with scheduling features make sure you
 * successfully authenticated your user by calling `NablaClient.getInstance().authenticate`.
 */
export class NablaSchedulingUI {

  /**
   * Launches the Appointment Booking Screen.
   *
   */
  public static navigateToScheduleAppointmentScreen() {
    nablaSchedulingUIModule.navigateToScheduleAppointmentScreen()
  }

  /**
   * Launches the AppointmentDetail Screen.
   * @param appoinmentIdId the id of the conversation to display.
   * @param errorCallback optional callback called in case of error. (Bad appointmentId)
   */
  public static navigateToAppointmentDetailScreen(
    appoinmentId: AppointmentId,
    errorCallback: (error: NablaError) => void = () => {}
  ) {
    nablaSchedulingUIModule.navigateToAppointmentDetailScreen(
      appoinmentId,
      mergeVoid(
        mapError,
        errorCallback,
        () => {},
      ),)
  }
}
