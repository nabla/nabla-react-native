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
        case let .patient(patient):
            result["type"] = "Patient"
            result["patient"] = patient.dictionaryRepresentation
        case .me:
            result["type"] = "Me"
        }
        return result
    }
}
