import { Conversation, RemoteId } from '../../../types';
import {
  mapProviderInConversation,
  NativeProviderInConversation,
} from '../NativeProviderInConversation';
import { mapConversation } from '../NativeConversation';

describe('mapConversation', () => {
  it('should correctly map to Conversation', () => {
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
    let nativeConversation = {
      id: new RemoteId('conversationId'),
      inboxPreviewTitle: 'inboxPreviewTitle',
      lastModified: '2000-01-23T01:23:45.678+09:00',
      patientUnreadMessageCount: 1,
      providers: [nativeProviderInConversation],
      title: null,
      lastMessagePreview: null,
      isLocked: true,
    };
    // When
    const result = mapConversation(nativeConversation);
    // Then
    expect(result).toStrictEqual(
      new Conversation(
        nativeConversation.id,
        nativeConversation.inboxPreviewTitle,
        new Date(nativeConversation.lastModified),
        nativeConversation.patientUnreadMessageCount,
        nativeConversation.providers.map(mapProviderInConversation),
        nativeConversation.isLocked,
        nativeConversation.title,
        nativeConversation.lastMessagePreview,
      ),
    );
  });
});
