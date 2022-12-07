import Foundation
import NablaCore
import NablaMessagingCore

extension PaginatedList where T == Conversation {
    var dictionaryRepresentation: [String: Any] {
        [
            "conversations": elements.map(\.dictionaryRepresentation),
            "hasMore": hasMore
        ]
    }
}
