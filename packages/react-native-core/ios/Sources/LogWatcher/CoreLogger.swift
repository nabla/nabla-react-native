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

    public func info(message: @autoclosure () -> String, extra: [String: Any]) {
        if logLevel.isAtLeast(.info) {
            Self.logsSubject.send(
                Log(level: .info, message: message(), error: extractNablaErrorFromExtra(extra))
            )
        }
    }

    public func warning(message: @autoclosure () -> String, extra: [String: Any]) {
        if logLevel.isAtLeast(.warn) {
            Self.logsSubject.send(
                Log(level: .warn, message: message(), error: extractNablaErrorFromExtra(extra))
            )
        }
    }

    public func error(message: @autoclosure () -> String, extra: [String: Any]) {
        if logLevel.isAtLeast(.error) {
            Self.logsSubject.send(
                Log(level: .error, message: message(), error: extractNablaErrorFromExtra(extra))
            )
        }
    }

    private func extractNablaErrorFromExtra(_ extra: [String: Any]) -> NablaError? {
        let error = (extra["error"] as? Error) ?? (extra["reason"] as? Error)
        return (error as? NablaError) ?? error.map(InternalError.init)
    }
}
