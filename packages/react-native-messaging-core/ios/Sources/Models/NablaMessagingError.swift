import NablaCore
import nabla_react_native_core
import NablaMessagingCore

private enum Constants {
    static let codeKey = "code"
    static let messageKey = "message"
}

extension InvalidMessageError {
    override public var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 20
        ]
    }
}

extension MessageNotFoundError {
    override public var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 21
        ]
    }
}

extension CanNotReadFileDataError {
    override public var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 22
        ]
    }
}

extension ProviderNotFoundError {
    override public var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 23,
            Constants.messageKey: message
        ]
    }
}

extension ProviderMissingPermissionError {
    override public var dictionaryRepresentation: [String: Any] {
        [
            Constants.codeKey: 24,
            Constants.messageKey: message
        ]
    }
}
