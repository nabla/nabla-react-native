import NablaCore

private enum Constants {
    static let codeKey = "code"
    static let messageKey = "message"
    static let extraKey = "extra"
}

extension Error {
    public var dictionaryRepresentation: [String: Any] {
        (self as? NablaError)?.dictionaryRepresentation ?? NablaError.unknownErrorDictionaryRepresentation
    }
}

extension NablaError {

    static var unknownErrorDictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 3 // UnknownError
        ]
    }

    @objc open var dictionaryRepresentation: [String: Any] {
        Self.unknownErrorDictionaryRepresentation
    }
}

extension NetworkError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 0,
            Constants.messageKey: message
        ]
    }
}

extension ServerError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 1,
            Constants.messageKey: message,
            Constants.extraKey: ["underlyingError": underlyingError]
        ]
    }
}

extension InternalError {
    private static var code = 2

    public static func createDictionaryRepresentation(
        message: String? = nil,
        underlyingError: Error? = nil
    ) -> [String: Any] {
        var result: [String: Any] = [Constants.codeKey: code]
        message.flatMap { result[Constants.messageKey] = $0 }
        underlyingError.flatMap { result[Constants.extraKey] = ["underlyingError": $0] }
        return result
    }

    public override var dictionaryRepresentation: [String: Any] {
        Self.createDictionaryRepresentation(message: nil, underlyingError: underlyingError)
    }
}

extension MissingAuthenticationProviderError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 10
        ]
    }
}

extension AuthenticationProviderFailedToProvideTokensError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 11
        ]
    }
}

extension AuthenticationProviderDidProvideExpiredTokensError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 12
        ]
    }
}

extension AuthorizationDeniedError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 13,
            Constants.extraKey: ["reason": reason]
        ]
    }
}

extension FailedToRefreshTokensError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 14,
            Constants.extraKey: ["reason": reason]
        ]
    }
}
