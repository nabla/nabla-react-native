import Foundation
import NablaMessagingCore

extension Provider {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["id"] = id
        result["avatarURL"] = avatarURL
        result["prefix"] = prefix
        result["firstName"] = firstName
        result["lastName"] = lastName
        return result
    }
}
