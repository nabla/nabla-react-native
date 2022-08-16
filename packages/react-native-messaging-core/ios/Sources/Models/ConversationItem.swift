import Foundation
import NablaMessagingCore

extension ConversationItem {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()

        result["createdAt"] = date.iso8601String

        if let conversationActivity = self as? ConversationActivity {
            result["id"] = id.uuidString
            result["type"] = "ConversationActivity"
            result["activity"] = conversationActivity.activity.dictionaryRepresentation
            return result
        }

        if let conversationMessage = self as? ConversationMessage {
            result["id"] = id.dictionaryRepresentation
            result["type"] = "ConversationMessage"
            result["sender"] = conversationMessage.sender.dictionaryRepresentation
            result["sendingState"] = conversationMessage.sendingState.dictionaryValue
            result["replyTo"] = conversationMessage.replyTo?.dictionaryRepresentation
        }

        switch self {
        case let deleteMessageItem as DeletedMessageItem:
            result["content"] = ["type": "DeletedMessageItem"]
        case let textMessageItem as TextMessageItem:
            result["content"] = [
                "type": "TextMessageItem",
                "text": textMessageItem.content
            ]
        case let imageMessageItem as ImageMessageItem:
            result["content"] = [
                "type": "ImageMessageItem",
                "image": imageMessageItem.content.dictionaryRepresentation
            ]
        case let videoMessageItem as VideoMessageItem:
            result["content"] = [
                "type": "VideoMessageItem",
                "video": videoMessageItem.content.dictionaryRepresentation
            ]
        case let documentMessageItem as DocumentMessageItem:
            result["content"] = [
                "type": "DocumentMessageItem",
                "document": documentMessageItem.content.dictionaryRepresentation
            ]
        case let audioMessageItem as AudioMessageItem:
            result["content"] = [
                "type": "AudioMessageItem",
                "audio": audioMessageItem.content.dictionaryRepresentation
            ]
        default:
            result["type"] = "UnknownItem"
        }
        return result
    }
}
