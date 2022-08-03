import { NativeError } from './NativeError';
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
  NablaError,
  NetworkError,
  ServerError,
  UnknownError,
} from '../types';

export const mapCoreError: (error: NativeError) => NablaError = (error) => {
  const { code, message, extra } = error;
  switch (code) {
    case 0:
      return new NetworkError(message, extra);
    case 1:
      return new ServerError(message, extra);
    case 2:
      return new InternalError(message, extra);
    case 3:
      return new UnknownError(message, extra);
    case 4:
      return new InvalidAndroidAppThemeError(message, extra);
    case 10:
      return new MissingAuthenticationProviderError(message, extra);
    case 11:
      return new AuthenticationProviderFailedToProvideTokensError(
        message,
        extra,
      );
    case 12:
      return new AuthenticationProviderDidProvideExpiredTokensError(
        message,
        extra,
      );
    case 13:
      return new AuthorizationDeniedError(message, extra);
    case 14:
      return new FailedToRefreshTokensError(message, extra);
    case 30:
      return new MissingApiKeyError(message, extra);
    case 31:
      return new MissingAndroidContextError(message, extra);
    case 33:
      return new MissingInitializeError(message, extra);
    default:
      return new UnknownError(message, extra);
  }
};
