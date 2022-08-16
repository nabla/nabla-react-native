import Foundation
import NablaMessagingCore

extension ConversationItems {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["hasMore"] = hasMore
        // TODO: remove the `reverse()` after the next release of the iOS SDK
        result["items"] = items.reversed().map(\.dictionaryRepresentation)
        return result
    }
}
