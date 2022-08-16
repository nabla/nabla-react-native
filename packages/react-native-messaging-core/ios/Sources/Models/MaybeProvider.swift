import Foundation
import NablaMessagingCore

extension MaybeProvider {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        switch self {
        case let .provider(provider):
            result["type"] = "Provider"
            result["provider"] = provider.dictionaryRepresentation
        case let .deletedProvider:
            result["type"] = "DeletedProvider"
        }
        return result
    }
}
