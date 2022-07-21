import {
  NablaAuthenticationError,
  NablaCommonError,
  NablaConfigurationError,
  NablaMessagingError,
} from '../../../types';
import { mapError } from '../ErrorMapper';

describe('mapNativeError', () => {
  it.each([
    [
      { code: 0, message: 'message', extra: { reason: 'reason' } },
      NablaCommonError.NetworkError,
    ],
    [
      { code: 1, message: 'message', extra: { reason: 'reason' } },
      NablaCommonError.ServerError,
    ],
    [
      { code: 2, message: 'message', extra: { reason: 'reason' } },
      NablaCommonError.InternalError,
    ],
    [
      { code: 3, message: 'message', extra: { reason: 'reason' } },
      NablaCommonError.UnknownError,
    ],
    [
      { code: 4, message: 'message', extra: { reason: 'reason' } },
      NablaCommonError.InvalidAndroidAppTheme,
    ],
    [
      { code: 10, message: 'message', extra: { reason: 'reason' } },
      NablaAuthenticationError.MissingAuthenticationProvider,
    ],
    [
      { code: 11, message: 'message', extra: { reason: 'reason' } },
      NablaAuthenticationError.AuthenticationProviderFailedToProvideTokens,
    ],
    [
      { code: 12, message: 'message', extra: { reason: 'reason' } },
      NablaAuthenticationError.AuthenticationProviderDidProvideExpiredTokens,
    ],
    [
      { code: 13, message: 'message', extra: { reason: 'reason' } },
      NablaAuthenticationError.AuthorizationDenied,
    ],
    [
      { code: 14, message: 'message', extra: { reason: 'reason' } },
      NablaAuthenticationError.FailedToRefreshTokens,
    ],
    [
      { code: 20, message: 'message', extra: { reason: 'reason' } },
      NablaMessagingError.InvalidMessage,
    ],
    [
      { code: 21, message: 'message', extra: { reason: 'reason' } },
      NablaMessagingError.MessageNotFound,
    ],
    [
      { code: 22, message: 'message', extra: { reason: 'reason' } },
      NablaMessagingError.CannotReadFileData,
    ],
    [
      { code: 23, message: 'message', extra: { reason: 'reason' } },
      NablaMessagingError.ProviderNotFound,
    ],
    [
      { code: 24, message: 'message', extra: { reason: 'reason' } },
      NablaMessagingError.ProviderMissingPermission,
    ],
    [
      { code: 30, message: 'message', extra: { reason: 'reason' } },
      NablaConfigurationError.MissingApiKey,
    ],
    [
      { code: 31, message: 'message', extra: { reason: 'reason' } },
      NablaConfigurationError.MissingAndroidContext,
    ],
    [
      { code: 33, message: 'message', extra: { reason: 'reason' } },
      NablaConfigurationError.MissingInitialize,
    ],
    [
      { code: 99, message: 'message', extra: { reason: 'reason' } },
      NablaCommonError.UnknownError,
    ],
  ])('should map native error %s to %s', (nativeError, expectedErrorType) => {
    // When
    // @ts-ignore
    const mappedError = mapError(nativeError);
    // Then
    expect(mappedError.type).toBe(expectedErrorType);
    expect(mappedError.message).toEqual(nativeError.message);
    expect(mappedError.extra).toStrictEqual(nativeError.extra);
  });
});
