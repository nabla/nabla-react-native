import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(ConversationListWatcherModule)
final class ConversationListWatcherModule: RCTEventEmitter {

    private var conversationsWatcher: PaginatedWatcher?
    private var conversationsLoadMoreCancellable: Cancellable?

    private enum Event: String, CaseIterable {
        case watchConversationsUpdated
        case watchConversationsError
    }

    override func supportedEvents() -> [String]! {
        Event.allCases.map(\.rawValue)
    }

    override func startObserving() {
        conversationsWatcher = NablaMessagingClient.shared.watchConversations { result in
            switch result {
            case .success(let conversations):
                self.sendEvent(
                    withName: Event.watchConversationsUpdated.rawValue,
                    body: conversations.dictionaryRepresentation
                )
            case .failure(let error):
                self.sendEvent(
                    withName: Event.watchConversationsError.rawValue,
                    body: error.dictionaryRepresentation)
            }
        }
    }

    override func stopObserving() {
        conversationsWatcher?.cancel()
        conversationsWatcher = nil
    }

    @objc(loadMoreConversations:)
    func loadMoreConversations(
        callback: @escaping RCTResponseSenderBlock
    ) {
        conversationsLoadMoreCancellable = conversationsWatcher?.loadMore { result in
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

