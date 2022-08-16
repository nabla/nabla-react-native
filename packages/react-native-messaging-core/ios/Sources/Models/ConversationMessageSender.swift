import Foundation
import NablaMessagingCore

extension ConversationMessageSender {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        switch self {
        case .deleted:
            result["type"] = "Deleted"
        case .unknown:
            result["type"] = "Unknown"
        case let .system(provider):
            result["type"] = "System"
            result["system"] = provider.dictionaryRepresentation
        case let .provider(provider):
            result["type"] = "Provider"
            result["provider"] = provider.dictionaryRepresentation
        case .patient:
            result["type"] = "Patient"
        }
        return result
    }
}
