import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(ConversationWatcherModule)
final class ConversationWatcherModule: RCTEventEmitter {

    private var conversationWatchers: [UUID: Watcher] = [:]

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
        conversationWatchers.keys.forEach {
            conversationWatchers[$0] = nil
        }
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
        let conversationWatcher = NablaMessagingClient.shared.watchConversation(conversationId) { result in
            switch result {
            case .success(let conversation):
                self.sendEvent(
                    withName: Event.watchConversationUpdated.rawValue,
                    body: conversation.dictionaryRepresentation
                )
            case .failure(let error):
                var dictionaryRepresentation = error.dictionaryRepresentation
                dictionaryRepresentation["id"] = conversationId.uuidString
                self.sendEvent(
                    withName: Event.watchConversationError.rawValue,
                    body: dictionaryRepresentation
                )
            }
        }
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

