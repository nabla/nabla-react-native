export class NablaError extends Error {
  extra?: Map<string, any>;

  constructor(message: string, extra?: Map<string, any>) {
    super(message);
    this.extra = extra;
  }
}

export class NetworkError extends NablaError {}
export class ServerError extends NablaError {}
export class InternalError extends NablaError {}
export class UnknownError extends NablaError {}
export class InvalidAndroidAppThemeError extends NablaError {}

export class ConfigurationError extends NablaError {}
export class MissingApiKeyError extends ConfigurationError {}
export class MissingAndroidContextError extends ConfigurationError {}
export class MissingInitializeError extends ConfigurationError {}

export class AuthenticationError extends NablaError {}
export class UserIdNotSetError extends AuthenticationError {}
export class AuthenticationProviderFailedToProvideTokensError extends AuthenticationError {}
export class AuthenticationProviderDidProvideExpiredTokensError extends AuthenticationError {}
export class AuthorizationDeniedError extends AuthenticationError {}
export class FailedToRefreshTokensError extends AuthenticationError {}
export class UnknownAuthenticationError extends AuthenticationError {}
export class CurrentUserAlreadySetError extends AuthenticationError {}
