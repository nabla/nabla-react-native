import Foundation
import NablaMessagingCore

extension ConversationList {
    var dictionaryRepresentation: [String: Any] {
        [
            "conversations": conversations.map(\.dictionaryRepresentation),
            "hasMore": hasMore
        ]
    }
}
