import Foundation
import NablaMessagingCore

extension Conversation {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["id"] = ["type": "Remote", "remoteId": id.uuidString]
        result["title"] = title
        result["inboxPreviewTitle"] = inboxPreviewTitle
        result["lastMessagePreview"] = lastMessagePreview
        result["lastModified"] = lastModified.iso8601String
        result["patientUnreadMessageCount"] = patientUnreadMessageCount
        result["providers"] = providers.map(\.dictionaryRepresentation)
        return result
    }
}