import Foundation
import NablaMessagingCore

extension ConversationActivity.Content {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        switch self {
        case let .providerJoined(maybeProvider):
            result["type"] = "ProviderJoined"
            result["maybeProvider"] = maybeProvider.dictionaryRepresentation
        }
        return result
    }
}
