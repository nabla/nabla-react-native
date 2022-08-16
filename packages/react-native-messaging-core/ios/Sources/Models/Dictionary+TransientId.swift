import Foundation
import NablaMessagingCore
import NablaCore

extension Dictionary where Key == String, Value: Any {
    public var asConversationId: ConversationId? {
        asTransientId
    }

    var asMessageId: MessageId? {
        asTransientId
    }

    private var asTransientId: UUID? {
        guard let type = self["type"] as? String else {
            return nil
        }

        switch (type) {
        case "Local":
            return (self["clientId"] as? String).flatMap(UUID.init)
        case "Remote":
            return (self["remoteId"] as? String).flatMap(UUID.init)
        default: return nil
        }
    }
}
