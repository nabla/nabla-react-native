import XCTest
@testable import NablaCore
@testable import nabla_react_native_core

final class NablaErrorTest: XCTestCase {
    private let code = "code"
    private let message = "message"

    private func checkDictionaryRepresentation(
        of error: NablaError,
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

    func test_nablaError() {
        checkDictionaryRepresentation(
            of: NablaError(),
            expectedCode: 3,
            expectedMessage: nil)
    }
    func test_networkError() {
        checkDictionaryRepresentation(
            of: NetworkError(message: message),
            expectedCode: 0,
            expectedMessage: message)
    }

    func test_serverError() {
        checkDictionaryRepresentation(
            of: ServerError(message: message),
            expectedCode: 1,
            expectedMessage: message)
    }

    func test_internalError() {
        checkDictionaryRepresentation(
            of: InternalError(underlyingError: NablaError()),
            expectedCode: 2,
            expectedMessage: nil)
    }

    func test_missingAuthenticationProviderError() {
        checkDictionaryRepresentation(
            of: UserIdNotSetError(),
            expectedCode: 10,
            expectedMessage: nil)
    }

    func test_authenticationProviderFailedToProvideTokensError() {
        checkDictionaryRepresentation(
            of: AuthenticationProviderFailedToProvideTokensError(),
            expectedCode: 11,
            expectedMessage: nil)
    }

    func test_authenticationProviderDidProvideExpiredTokensError() {
        checkDictionaryRepresentation(
            of: AuthenticationProviderDidProvideExpiredTokensError(),
            expectedCode: 12,
            expectedMessage: nil)
    }

    func test_authorizationDeniedError() {
        checkDictionaryRepresentation(
            of: AuthorizationDeniedError(reason: NablaError()),
            expectedCode: 13,
            expectedMessage: nil)
    }

    func test_failedToRefreshTokensError() {
        checkDictionaryRepresentation(
            of: FailedToRefreshTokensError(reason: NablaError()),
            expectedCode: 14,
            expectedMessage: nil)
    }

    func test_createInternalErrorDictionaryRepresentation() {
        // Given

        // When
        let dictionaryRepresentation = InternalError.createDictionaryRepresentation(
            message: message,
            underlyingError: NablaError()
        )

        // Then
        XCTAssertEqual(2, dictionaryRepresentation[code] as? Int)
        XCTAssertEqual(message, dictionaryRepresentation[message] as? String)
    }

}