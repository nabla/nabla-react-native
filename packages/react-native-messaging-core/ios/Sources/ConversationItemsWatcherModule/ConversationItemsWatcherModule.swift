import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(ConversationItemsWatcherModule)
final class ConversationItemsWatcherModule: RCTEventEmitter {

    private var conversationItemsWatchers: [UUID: PaginatedWatcher] = [:]
    private var conversationItemsLoadMoreCancellables: [UUID: Cancellable] = [:]

    private enum Event: String, CaseIterable {
        case watchConversationItemsUpdated
        case watchConversationItemsError
    }

    override func supportedEvents() -> [String]! {
        Event.allCases.map(\.rawValue)
    }

    override func stopObserving() {
        conversationItemsWatchers.values.forEach {
            $0.cancel()
        }
        conversationItemsWatchers.keys.forEach {
            conversationItemsWatchers[$0] = nil
        }
        conversationItemsLoadMoreCancellables.values.forEach {
            $0.cancel()
        }
        conversationItemsLoadMoreCancellables.keys.forEach {
            conversationItemsWatchers[$0] = nil
        }
    }

    @objc(watchConversationItems:callback:)
    func watchConversationItems(
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asMessageId else {
            callback(
                [InternalError.createDictionaryRepresentation(message: "Bad ConversationId `\(conversationIdMap)`")]
            )
            return
        }
        let conversationItemsWatcher = NablaMessagingClient.shared.watchItems(ofConversationWithId: conversationId) { result in
            switch result {
            case .success(let conversationItems):
                var dictionaryRepresentation = conversationItems.dictionaryRepresentation
                dictionaryRepresentation["id"] = conversationIdMap
                self.sendEvent(withName: Event.watchConversationItemsUpdated.rawValue, body: dictionaryRepresentation)
            case .failure(let error):
                var dictionaryRepresentation = error.dictionaryRepresentation
                dictionaryRepresentation["id"] = conversationIdMap
                self.sendEvent(withName: Event.watchConversationItemsError.rawValue, body: dictionaryRepresentation)
            }
        }
        conversationItemsWatchers[conversationId] = conversationItemsWatcher
        callback([NSNull()])
    }

    @objc(unsubscribeFromConversationItems:)
    func unsubscribeFromConversationItems(
        conversationIdMap: [String: Any]
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            // This an internal method, so we can ignore exception
            // If we have a bad conversationId, the watchConversationItems
            // will fail before we get here
            return
        }
        conversationItemsWatchers[conversationId]?.cancel()
        conversationItemsWatchers[conversationId] = nil
        conversationItemsLoadMoreCancellables[conversationId]?.cancel()
        conversationItemsLoadMoreCancellables[conversationId] = nil
    }

    @objc(loadMoreItemsInConversation:errorCallback:)
    func loadMoreItemsInConversation(
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            callback([InternalError.createDictionaryRepresentation(message: "Bad ConversationId `\(conversationIdMap)`")])
            return
        }

        guard let conversationItemsWatcher = conversationItemsWatchers[conversationId] else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Need to watch conversation items before loading more items")
            ])
            return
        }

        let conversationItemsLoadMoreCancellable = conversationItemsWatcher.loadMore { result in
            switch result {
            case .success:
                callback([NSNull()])
            case .failure(let error):
                callback([(error as? NablaError)?.dictionaryRepresentation ?? [:]])
            }
        }
    }

    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}

