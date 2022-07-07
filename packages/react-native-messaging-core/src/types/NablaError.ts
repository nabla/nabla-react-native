export enum NablaCommonError {
  NetworkError = 'NetworkError',
  ServerError = 'ServerError',
  InternalError = 'InternalError',
  UnknownError = 'UnknownError',
  InvalidAndroidAppTheme = 'InvalidAndroidAppTheme',
}

export enum NablaConfigurationError {
  MissingApiKey = 'MissingApiKey',
  MissingAndroidContext = 'MissingAndroidContext',
  MissingInitialize = 'MissingInitialize',
}

export enum NablaMessagingError {
  InvalidMessage = 'InvalidMessage',
  MessageNotFound = 'MessageNotFound',
  CannotReadFileData = 'CannotReadFileData',
  ProviderNotFound = 'ProviderNotFound',
  ProviderMissingPermission = 'ProviderMissingPermission',
  MissingConversationId = 'MissingConversationId',
}

export enum NablaAuthenticationError {
  MissingAuthenticationProvider = 'MissingAuthenticationProvider',
  AuthenticationProviderFailedToProvideTokens = 'AuthenticationProviderFailedToProvideTokens',
  AuthenticationProviderDidProvideExpiredTokens = 'AuthenticationProviderDidProvideExpiredTokens',
  AuthorizationDenied = 'AuthorizationDenied',
  FailedToRefreshTokens = 'FailedToRefreshTokens',
}

export type NablaErrorType =
  | NablaCommonError
  | NablaAuthenticationError
  | NablaMessagingError
  | NablaConfigurationError;

export class NablaError extends Error {
  type: NablaErrorType;
  extra?: Map<string, any>;

  constructor(type: NablaErrorType, message: string, extra?: Map<string, any>) {
    super(message);
    this.type = type;
    this.extra = extra;
  }
}
