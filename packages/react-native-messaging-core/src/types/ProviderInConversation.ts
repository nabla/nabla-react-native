import { Provider } from './Provider';

export class ProviderInConversation {
  provider: Provider;
  typingAt?: Date;
  seenUntil?: Date;

  constructor(provider: Provider, typingAt?: Date, seenUntil?: Date) {
    this.provider = provider;
    this.typingAt = typingAt;
    this.seenUntil = seenUntil;
  }
}
