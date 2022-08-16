import Foundation
import NablaMessagingCore

public typealias ConversationId = UUID

extension ConversationId {
    var dictionaryRepresentation: [String: Any] {
        ["type": "Remote", "remoteId": uuidString]
    }
}
