import NablaCore

private enum Constants {
    static let codeKey = "code"
    static let messageKey = "message"
    static let extraKey = "extra"
    
    static let unknownErrorCode = 3
}

extension Error {
    public var dictionaryRepresentation: [String: Any] {
        (self as? NablaError)?.dictionaryRepresentation ?? [
            Constants.codeKey: Constants.unknownErrorCode
        ]
    }
}

extension NablaError {

    @objc open var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: Constants.unknownErrorCode,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension NetworkError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 0,
            Constants.messageKey: message,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension ServerError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 1,
            Constants.messageKey: message,
            Constants.extraKey: self.serialize()
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
        [
            Constants.codeKey: Self.code,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension UserIdNotSetError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 10,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension AuthenticationProviderFailedToProvideTokensError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 11,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension AuthenticationProviderDidProvideExpiredTokensError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 12,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension AuthorizationDeniedError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 13,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension FailedToRefreshTokensError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 14,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension UnknownAuthenticationError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 15,
            Constants.extraKey: self.serialize()
        ]
    }
}

extension CurrentUserAlreadySetError {
    public override var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 16,
            Constants.extraKey: self.serialize()
        ]
    }
}
