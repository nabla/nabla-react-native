import { EventSubscription } from 'react-native';

export class ConversationsEventSubscription {
  constructor(
    errorEventSubscription: EventSubscription,
    conversationsEventSubscription: EventSubscription,
  ) {
    this.errorEventSubscription = errorEventSubscription;
    this.conversationsEventSubscription = conversationsEventSubscription;
  }

  errorEventSubscription: EventSubscription;
  conversationsEventSubscription: EventSubscription;

  public remove() {
    this.errorEventSubscription.remove();
    this.conversationsEventSubscription.remove();
  }
}
