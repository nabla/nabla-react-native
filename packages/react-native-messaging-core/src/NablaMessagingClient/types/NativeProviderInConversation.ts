import { Provider, ProviderInConversation } from '../../types';

export interface NativeProviderInConversation {
  provider: Provider;
  typingAt?: string;
  seenUntil?: string;
}

export const mapProviderInConversation: (
  provider: NativeProviderInConversation,
) => ProviderInConversation = (provider) => {
  let typingAt;
  if (provider.typingAt) {
    typingAt = new Date(provider.typingAt);
  }
  let seenUntil;
  if (provider.seenUntil) {
    seenUntil = new Date(provider.seenUntil);
  }
  return new ProviderInConversation(provider.provider, typingAt, seenUntil);
};
