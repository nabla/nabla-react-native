import Foundation
import NablaMessagingCore

extension ConversationActivity.Activity {
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
