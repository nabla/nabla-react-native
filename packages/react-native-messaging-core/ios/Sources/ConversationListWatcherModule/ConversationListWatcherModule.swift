import Combine
import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(ConversationListWatcherModule)
final class ConversationListWatcherModule: RCTEventEmitter {

    private var conversationsWatcher: AnyCancellable?
    private var conversationsLoadMoreFunction: (() async throws -> Void)?

    private enum Event: String, CaseIterable {
        case watchConversationsUpdated
        case watchConversationsError
    }

    override func supportedEvents() -> [String]! {
        Event.allCases.map(\.rawValue)
    }

    override func startObserving() {
        conversationsWatcher = NablaMessagingClient.shared
            .watchConversations()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.sendEvent(
                            withName: Event.watchConversationsError.rawValue,
                            body: error.dictionaryRepresentation
                        )
                    }
                },
                receiveValue: { [weak self] conversations in
                    guard let self = self else {
                        return
                    }
                    self.sendEvent(
                        withName: Event.watchConversationsUpdated.rawValue,
                        body: conversations.dictionaryRepresentation
                    )
                })
    }

    override func stopObserving() {
        conversationsWatcher?.cancel()
        conversationsWatcher = nil
        conversationsLoadMoreFunction = nil
    }

    @objc(loadMoreConversations:)
    func loadMoreConversations(
        callback: @escaping RCTResponseSenderBlock
    ) {
        Task {
            do {
                try await conversationsLoadMoreFunction?()
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

