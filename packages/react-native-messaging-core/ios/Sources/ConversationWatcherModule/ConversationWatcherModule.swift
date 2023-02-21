import Combine
import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(ConversationWatcherModule)
final class ConversationWatcherModule: RCTEventEmitter {

    private var conversationWatchers: [UUID: AnyCancellable] = [:]

    private enum Event: String, CaseIterable {
        case watchConversationUpdated
        case watchConversationError
    }

    override func supportedEvents() -> [String]! {
        Event.allCases.map(\.rawValue)
    }

    override func stopObserving() {
        conversationWatchers.values.forEach {
            $0.cancel()
        }
        conversationWatchers.removeAll()
    }

    @objc(watchConversation:callback:)
    func watchConversation(
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad ConversationId `\(conversationIdMap)`")
            ])
            return
        }

        let conversationWatcher = NablaMessagingClient.shared
            .watchConversation(withId: conversationId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        var dictionaryRepresentation = error.dictionaryRepresentation
                        dictionaryRepresentation["id"] = conversationId.uuidString
                        self.sendEvent(
                            withName: Event.watchConversationError.rawValue,
                            body: dictionaryRepresentation
                        )
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    self.sendEvent(
                        withName: Event.watchConversationUpdated.rawValue,
                        body: response.dictionaryRepresentation(\.dictionaryRepresentation)
                    )
                }
            )
        conversationWatchers[conversationId] = conversationWatcher
        callback([NSNull()])
    }

    @objc(unsubscribeFromConversation:)
    func unsubscribeFromConversation(conversationIdMap: [String: Any]) {
        guard let conversationId = conversationIdMap.asConversationId else {
            return
        }
        conversationWatchers[conversationId]?.cancel()
        conversationWatchers[conversationId] = nil
    }

    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}

