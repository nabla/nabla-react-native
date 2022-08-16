import Foundation
import NablaMessagingCore

extension SystemProvider {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["avatarURL"] = avatarURL
        result["name"] = name
        return result
    }
}
