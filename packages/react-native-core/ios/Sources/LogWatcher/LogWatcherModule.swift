import Foundation
import NablaCore
import Combine

@objc(LogWatcherModule)
final class LogWatcherModule: RCTEventEmitter {

    @objc(setLogLevel:)
    func setLoglevel(_ logLevel: String) {
        CoreLogger.sharedInstance.setLogLevel(logLevel)
    }

    // MARK: - Overridden

    override func startObserving() {
        logsCancellable = CoreLogger.logsSubject.sink { [weak self] log in
            self?.sendLogEvent(log)
        }
    }

    override func stopObserving() {
        logsCancellable?.cancel()
    }

    override func supportedEvents() -> [String]! {
        Event.allCases.map(\.rawValue)
    }

    @objc(requiresMainQueueSetup)
    override static func requiresMainQueueSetup() -> Bool {
        false
    }

    // MARK: - Private

    private enum Event: String, CaseIterable {
        case log
    }

    private var logsCancellable: AnyCancellable?

    private func sendLogEvent(_ log: Log) {
        sendEvent(
            withName: Event.log.rawValue,
            body: [
                "level": log.level.stringValue,
                "tag": "Nabla-SDK",
                "message": log.message,
                "error": log.error?.dictionaryRepresentation
            ])
    }
}
