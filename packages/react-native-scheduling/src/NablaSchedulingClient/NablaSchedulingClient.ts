import { nablaSchedulingClientModule } from './NablaSchedulingModule';

/**
 * Main entry-point to SDK-wide features.
 */
export class NablaSchedulingClient {

  /**
   * Initializes the Scheduling module and register it on `NablaClient`
   * Must be called before `NablaClient.getInstance().initialize()`
   */
  public static async initializeSchedulingModule() {
    await nablaSchedulingClientModule.initializeSchedulingModule();
  }

  public static openScheduleAppointmentScreen() {
    nablaSchedulingClientModule.openScheduleAppointmentScreen()
  }
}
