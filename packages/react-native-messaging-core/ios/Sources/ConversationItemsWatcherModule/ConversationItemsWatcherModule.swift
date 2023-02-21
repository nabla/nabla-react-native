import Combine
import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(ConversationItemsWatcherModule)
final class ConversationItemsWatcherModule: RCTEventEmitter {

    private var conversationItemsWatchers: [UUID: AnyCancellable] = [:]
    private var conversationItemsLoadMoreFunctions: [UUID: () async throws -> Void] = [:]

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
        conversationItemsWatchers.removeAll()
        conversationItemsLoadMoreFunctions.removeAll()
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

        let conversationItemsWatcher = NablaMessagingClient.shared.watchItems(ofConversationWithId: conversationId)
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
                        dictionaryRepresentation["id"] = conversationIdMap
                        self.conversationItemsLoadMoreFunctions[conversationId] = nil
                        self.sendEvent(
                            withName: Event.watchConversationItemsError.rawValue,
                            body: dictionaryRepresentation
                        )
                    }

                },
                receiveValue: { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    let dictionaryRepresentation = response.dictionaryRepresentation { list in
                        var dictionaryRepresentation = list.dictionaryRepresentation(\.dictionaryRepresentation)
                        dictionaryRepresentation["id"] = conversationIdMap
                        return dictionaryRepresentation
                    }
                    self.conversationItemsLoadMoreFunctions[conversationId] = response.data.loadMore
                    self.sendEvent(
                        withName: Event.watchConversationItemsUpdated.rawValue,
                        body: dictionaryRepresentation
                    )
                })

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
        conversationItemsLoadMoreFunctions[conversationId] = nil
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

        guard conversationItemsWatchers[conversationId] != nil else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Need to watch conversation items before loading more items")
            ])
            return
        }

        Task {
            do {
                try await self.conversationItemsLoadMoreFunctions[conversationId]?()
                callback([NSNull()])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}

