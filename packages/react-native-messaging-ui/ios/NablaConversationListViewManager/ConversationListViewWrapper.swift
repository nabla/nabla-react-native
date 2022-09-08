import Foundation
import NablaCore
import NablaMessagingCore
import NablaMessagingUI
import UIKit

final class ConversationListViewWrapper: UIView {
    init() {
        super.init(frame: .zero)
        let view = NablaClient.shared.messaging.views.createConversationListView(delegate: self)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    @objc private var onConversationSelected: RCTDirectEventBlock?
}

extension ConversationListViewWrapper: ConversationListDelegate {
    func conversationList(didSelect conversation: Conversation) {
        onConversationSelected?(["conversationId": conversation.id.dictionaryRepresentation])
    }
}
