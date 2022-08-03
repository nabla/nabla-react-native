import XCTest
@testable import NablaMessagingCore
@testable import nabla_react_native_messaging_core

final class NablaMessagingErrorTest: XCTestCase {
    private let code = "code"
    private let message = "message"

    private func checkDictionaryRepresentation(
        of error: MessagingError,
        expectedCode: Int,
        expectedMessage: String?,
        line: UInt = #line
    ) {
        // Given

        // When
        let dictionaryRepresentation = error.dictionaryRepresentation

        // Then
        XCTAssertEqual(expectedCode, dictionaryRepresentation[code] as? Int, line: line)
        XCTAssertEqual(expectedMessage, dictionaryRepresentation[message] as? String, line: line)
    }

    func test_messagingError() {
        checkDictionaryRepresentation(
            of: MessagingError(),
            expectedCode: 3,
            expectedMessage: nil)
    }

    func test_invalidMessageError() {
        checkDictionaryRepresentation(
            of: InvalidMessageError(),
            expectedCode: 20,
            expectedMessage: nil)
    }

    func test_messageNotFoundError() {
        checkDictionaryRepresentation(
            of: MessageNotFoundError(),
            expectedCode: 21,
            expectedMessage: nil)
    }

    func test_canNotReadFileDataError() {
        checkDictionaryRepresentation(
            of: CanNotReadFileDataError(),
            expectedCode: 22,
            expectedMessage: nil)
    }

    func test_providerNotFoundError() {
        checkDictionaryRepresentation(
            of: ProviderNotFoundError(message: message),
            expectedCode: 23,
            expectedMessage: message)
    }

    func test_providerMissingPermissionError() {
        checkDictionaryRepresentation(
            of: ProviderMissingPermissionError(message: message),
            expectedCode: 24,
            expectedMessage: message)
    }
}