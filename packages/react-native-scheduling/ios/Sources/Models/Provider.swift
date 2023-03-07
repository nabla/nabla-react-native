import Foundation
import NablaScheduling

extension Provider {
    var dictionaryRepresentation: [String: Any] {
        var result = [
            "id": id.uuidString,
            "firstName": firstName,
            "lastName": lastName,
        ]
        result["title"] = title
        result["prefix"] = prefix
        result["avatarUrl"] = avatarUrl?.absoluteString
        return result
    }
}
