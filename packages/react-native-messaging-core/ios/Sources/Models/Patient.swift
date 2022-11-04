import Foundation
import NablaMessagingCore

extension Patient {
    var dictionaryRepresentation: [String: Any] {
        [
            "id": id.uuidString,
            "displayName": displayName
        ]
    }
}
