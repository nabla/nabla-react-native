import {
  NablaAuthenticationError,
  NablaCommonError,
  NablaConfigurationError,
  NablaError,
  NablaMessagingError,
} from '../../types';
import { NativeError } from './NativeError';

export const mapError: (error: NativeError) => NablaError = (error) => {
  const { code, message, extra } = error;
  switch (code) {
    case 0:
      return new NablaError(NablaCommonError.NetworkError, message, extra);
    case 1:
      return new NablaError(NablaCommonError.ServerError, message, extra);
    case 2:
      return new NablaError(NablaCommonError.InternalError, message, extra);
    case 3:
      return new NablaError(NablaCommonError.UnknownError, message, extra);
    case 4:
      return new NablaError(
        NablaCommonError.InvalidAndroidAppTheme,
        message,
        extra,
      );
    case 10:
      return new NablaError(
        NablaAuthenticationError.MissingAuthenticationProvider,
        message,
        extra,
      );
    case 11:
      return new NablaError(
        NablaAuthenticationError.AuthenticationProviderFailedToProvideTokens,
        message,
        extra,
      );
    case 12:
      return new NablaError(
        NablaAuthenticationError.AuthenticationProviderDidProvideExpiredTokens,
        message,
        extra,
      );
    case 13:
      return new NablaError(
        NablaAuthenticationError.AuthorizationDenied,
        message,
        extra,
      );
    case 14:
      return new NablaError(
        NablaAuthenticationError.FailedToRefreshTokens,
        message,
        extra,
      );
    case 20:
      return new NablaError(NablaMessagingError.InvalidMessage, message, extra);
    case 21:
      return new NablaError(
        NablaMessagingError.MessageNotFound,
        message,
        extra,
      );
    case 22:
      return new NablaError(
        NablaMessagingError.CannotReadFileData,
        message,
        extra,
      );
    case 23:
      return new NablaError(
        NablaMessagingError.ProviderNotFound,
        message,
        extra,
      );
    case 24:
      return new NablaError(
        NablaMessagingError.ProviderMissingPermission,
        message,
        extra,
      );
    case 25:
      return new NablaError(
        NablaMessagingError.MissingConversationId,
        message,
        extra,
      );
    case 30:
      return new NablaError(
        NablaConfigurationError.MissingApiKey,
        message,
        extra,
      );
    case 31:
      return new NablaError(
        NablaConfigurationError.MissingAndroidContext,
        message,
        extra,
      );
    case 33:
      return new NablaError(
        NablaConfigurationError.MissingInitialize,
        message,
        extra,
      );
    default:
      return new NablaError(NablaCommonError.UnknownError, message, extra);
  }
};
