import Foundation
import NablaMessagingCore

extension ConversationItems {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["hasMore"] = hasMore
        result["items"] = items.map(\.dictionaryRepresentation)
        return result
    }
}
