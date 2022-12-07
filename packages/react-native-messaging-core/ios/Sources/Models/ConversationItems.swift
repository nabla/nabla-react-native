import Foundation
import NablaCore
import NablaMessagingCore

extension PaginatedList where T == ConversationItem {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["hasMore"] = hasMore
        result["items"] = elements.map(\.dictionaryRepresentation)
        return result
    }
}
