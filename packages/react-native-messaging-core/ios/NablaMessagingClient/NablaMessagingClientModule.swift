import Foundation
import NablaCore
import NablaMessagingCore

@objc(NablaMessagingClientModule)
final class NablaMessagingClientModule: RCTEventEmitter {

    private var conversationsWatcher: PaginatedWatcher?
    private var conversationsLoadMoreCancellable: Cancellable?
    private var createConversationCancellable: Cancellable?

    enum Event: String, CaseIterable {
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

    @objc(createConversation:providerIds:callback:)
    func createConversation(
        title: String?,
        providerIds: [String]?,
        callback: @escaping RCTResponseSenderBlock
    ) {
        createConversationCancellable = NablaMessagingClient.shared.createConversation(
            title: title,
            providerIds: providerIds?.compactMap(UUID.init)
        ) { result in
            switch result {
            case .success(let conversation):
                callback([NSNull(), conversation.id.uuidString])
            case .failure(let error):
                callback([error.dictionaryRepresentation])
            }
        }
    }

    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}
