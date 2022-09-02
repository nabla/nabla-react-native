import Foundation
import NablaMessagingCore

public typealias ConversationId = UUID

public extension ConversationId {
    var dictionaryRepresentation: [String: Any] {
        ["type": "Remote", "remoteId": uuidString]
    }
}
