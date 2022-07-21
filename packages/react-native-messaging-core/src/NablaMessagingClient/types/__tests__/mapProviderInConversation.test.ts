import {
  mapProviderInConversation,
  NativeProviderInConversation,
} from '../NativeProviderInConversation';
import { ProviderInConversation } from '../../../types';

describe('mapProviderInConversation', () => {
  it('should correctly map to ProviderInConversation', () => {
    // Given
    let provider = {
      id: 'providerId',
      firstName: 'firstName',
      lastName: 'lastName',
    };
    const nativeProviderInConversation: NativeProviderInConversation = {
      provider,
      typingAt: '2000-01-23T01:23:45.678+09:00',
      seenUntil: '2000-01-23T01:23:45.678+09:00',
    };
    // When
    const result = mapProviderInConversation(nativeProviderInConversation);
    // Then
    expect(result).toStrictEqual(
      new ProviderInConversation(
        provider,
        new Date(nativeProviderInConversation.typingAt),
        new Date(nativeProviderInConversation.seenUntil),
      ),
    );
  });
});
