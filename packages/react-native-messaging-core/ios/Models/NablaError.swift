import NablaCore
import NablaMessagingCore

extension NablaError {

    fileprivate struct NativeError {
        let code: Int
        let message: String
        let extra: [String: Any]

        init(code: Int, message: String? = nil, extra: [String: Any]? = nil) {
            self.code = code
            self.message = message ?? ""
            self.extra = extra ?? [:]
        }
    }

    var dictionaryRepresentation: [String: Any] {
        [
            "code": nativeError.code,
            "message": nativeError.message,
            "extra": nativeError.extra,
        ]
    }

    private var code: Int {
        switch self {
//        case is NetworkError: return 0
        case is ServerError: return 1
        case is InternalError: return 2
        case is MissingAuthenticationProviderError: return 10
        case is AuthenticationProviderFailedToProvideTokensError: return 11
        case is AuthenticationProviderDidProvideExpiredTokensError: return 12
        case is AuthorizationDeniedError: return 13
        case is FailedToRefreshTokensError: return 14

        case is InvalidMessageError: return 20
        case is MessageNotFoundError: return 21
        case is CanNotReadFileDataError: return 22
        case is ProviderNotFoundError: return 23
        case is ProviderMissingPermissionError: return 24
        default:
            return 3 // UnknownError
        }
    }


    private var nativeError: NativeError {

        switch self {
        case let error as ServerError:
            return .init(
                code: 1,
                message: error.message,
                extra: ["underlyingError": error.underlyingError]
            )
        case let error as InternalError:
            return .init(code: 2, extra: ["underlyingError": error.underlyingError])
        case let error as MissingAuthenticationProviderError:
            return .init(code: 10)
        case let error as AuthenticationProviderFailedToProvideTokensError:
            return .init(code: 11)
        case let error as AuthenticationProviderDidProvideExpiredTokensError:
            return .init(code: 12)
        case let error as AuthorizationDeniedError:
            return .init(code: 13, extra: ["reason": error.reason])
        case let error as FailedToRefreshTokensError:
            return .init(code: 14, extra: ["reason": error.reason])
        case let error as InvalidMessageError:
            return .init(code: 20)
        case let error as MessageNotFoundError:
            return .init(code: 21)
        case let error as CanNotReadFileDataError:
            return .init(code: 22)
        case let error as ProviderNotFoundError:
            return .init(code: 23, message: error.message)
        case let error as ProviderMissingPermissionError:
            return .init(code: 24, message: error.message)
        default:
            return .init(code: 3) // UnknownError
        }
    }
}
