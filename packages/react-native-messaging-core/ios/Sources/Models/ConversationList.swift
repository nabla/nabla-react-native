import Foundation
import NablaCore
import NablaMessagingCore

extension PaginatedList where Element == Conversation {
    var dictionaryRepresentation: [String: Any] {
        [
            "conversations": elements.map(\.dictionaryRepresentation),
            "hasMore": hasMore
        ]
    }
}
