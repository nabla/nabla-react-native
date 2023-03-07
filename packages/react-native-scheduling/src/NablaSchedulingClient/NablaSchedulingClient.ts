import { nablaSchedulingClientModule } from './NablaSchedulingModule';
import { AppRegistry, ComponentProvider } from 'react-native';

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

  public static registerCustomPaymentComponent(
    getComponentFunc: ComponentProvider,
  ) {
    const componentName = 'NablaSchedulingPaymentStep';
    AppRegistry.registerComponent(componentName, getComponentFunc);
    nablaSchedulingClientModule.setupCustomPaymentStep(componentName);
  }

  public static didSucceedPaymentStep() {
    nablaSchedulingClientModule.didSucceedPaymentStep();
  }

  public static didFailPaymentStep() {
    nablaSchedulingClientModule.didFailPaymentStep();
  }
}
