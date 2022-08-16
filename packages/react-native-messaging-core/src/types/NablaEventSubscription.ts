import { EventSubscription } from 'react-native';

export class NablaEventSubscription {
  constructor(
    errorEventSubscription: EventSubscription,
    successEventSubscription: EventSubscription,
    cleanup: (() => void) | undefined = undefined,
  ) {
    this.errorEventSubscription = errorEventSubscription;
    this.successEventSubscription = successEventSubscription;
    this.cleanup = cleanup;
  }

  private readonly cleanup: (() => void) | undefined;
  private readonly errorEventSubscription: EventSubscription;
  private readonly successEventSubscription: EventSubscription;

  public remove() {
    this.errorEventSubscription.remove();
    this.successEventSubscription.remove();
    if (this.cleanup) {
      this.cleanup();
    }
  }
}
