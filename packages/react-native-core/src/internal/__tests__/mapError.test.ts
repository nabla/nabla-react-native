import { mapCoreError } from '../index';
import {
  AuthenticationProviderDidProvideExpiredTokensError,
  AuthenticationProviderFailedToProvideTokensError,
  AuthorizationDeniedError,
  FailedToRefreshTokensError,
  InternalError,
  InvalidAndroidAppThemeError,
  MissingAndroidContextError,
  MissingApiKeyError,
  MissingAuthenticationProviderError,
  MissingInitializeError,
  NetworkError,
  ServerError,
  UnknownError,
} from '../../types';

describe('mapCoreError', () => {
  it.each([
    [
      { code: 0, message: 'message', extra: { reason: 'reason' } },
      NetworkError,
    ],
    [{ code: 1, message: 'message', extra: { reason: 'reason' } }, ServerError],
    [
      { code: 2, message: 'message', extra: { reason: 'reason' } },
      InternalError,
    ],
    [
      { code: 3, message: 'message', extra: { reason: 'reason' } },
      UnknownError,
    ],
    [
      { code: 4, message: 'message', extra: { reason: 'reason' } },
      InvalidAndroidAppThemeError,
    ],
    [
      { code: 10, message: 'message', extra: { reason: 'reason' } },
      MissingAuthenticationProviderError,
    ],
    [
      { code: 11, message: 'message', extra: { reason: 'reason' } },
      AuthenticationProviderFailedToProvideTokensError,
    ],
    [
      { code: 12, message: 'message', extra: { reason: 'reason' } },
      AuthenticationProviderDidProvideExpiredTokensError,
    ],
    [
      { code: 13, message: 'message', extra: { reason: 'reason' } },
      AuthorizationDeniedError,
    ],
    [
      { code: 14, message: 'message', extra: { reason: 'reason' } },
      FailedToRefreshTokensError,
    ],
    [
      { code: 30, message: 'message', extra: { reason: 'reason' } },
      MissingApiKeyError,
    ],
    [
      { code: 31, message: 'message', extra: { reason: 'reason' } },
      MissingAndroidContextError,
    ],
    [
      { code: 33, message: 'message', extra: { reason: 'reason' } },
      MissingInitializeError,
    ],
    [
      { code: 99, message: 'message', extra: { reason: 'reason' } },
      UnknownError,
    ],
  ])('should map native error %s to %s', (nativeError, expectedErrorType) => {
    // When
    // @ts-ignore
    const mappedError = mapCoreError(nativeError);
    // Then
    expect(mappedError instanceof expectedErrorType).toBeTruthy();
    expect(mappedError.message).toEqual(nativeError.message);
    expect(mappedError.message).toEqual(nativeError.message);
  });
});
