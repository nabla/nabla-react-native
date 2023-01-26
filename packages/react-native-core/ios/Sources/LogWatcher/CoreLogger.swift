import Combine
import Foundation
import NablaCore


public final class CoreLogger {

    public static let sharedInstance = CoreLogger()
    static let logsSubject = PassthroughSubject<Log, Never>()

    func setLogLevel(_ level: String) {
        switch level.lowercased() {
        case Log.Level.debug.stringValue: logLevel = .info
        case Log.Level.info.stringValue: logLevel = .info
        case Log.Level.warn.stringValue: logLevel = .warn
        case Log.Level.error.stringValue: logLevel = .error
        default: warning(message: "Incorrect log level input `\(level)`")
        }
    }

    private var logLevel: Log.Level = .warn
    private init() {}
}

extension CoreLogger: NablaCore.Logger {

    public func debug(message: @autoclosure () -> String, error: Error?, extra: [String: Any]) {
        if logLevel.isAtLeast(.debug) {
            Self.logsSubject.send(
                Log(level: .debug, message: message(), error: error?.asNablaError())
            )
        }
    }

    public func info(message: @autoclosure () -> String, error: Error?, extra: [String: Any]) {
        if logLevel.isAtLeast(.info) {
            Self.logsSubject.send(
                Log(level: .info, message: message(), error: error?.asNablaError())
            )
        }
    }

    public func warning(message: @autoclosure () -> String, error: Error?, extra: [String: Any]) {
        if logLevel.isAtLeast(.warn) {
            Self.logsSubject.send(
                Log(level: .warn, message: message(), error: error?.asNablaError())
            )
        }
    }

    public func error(message: @autoclosure () -> String, error: Error?, extra: [String: Any]) {
        if logLevel.isAtLeast(.error) {
            Self.logsSubject.send(
                Log(level: .error, message: message(), error: error?.asNablaError())
            )
        }
    }
}

extension Error {
    fileprivate func asNablaError() -> NablaError {
        (self as? NablaError) ?? InternalError(underlyingError: self)
    }
}
