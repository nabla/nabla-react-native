import Foundation
import NablaMessagingCore

extension MediaSize {
    var dictionaryRepresentation: [String: Any] {
        [
            "width": width,
            "height": height
        ]
    }
}

extension Media {
    var dictionaryRepresentation: [String: Any] {
        var result = [String: Any]()
        result["fileName"] = fileName

        switch content {
        case let .url(url):
            result["content"] = [
                "type": "url",
                "fileURL": url.absoluteString
            ]
        case let .data(data):
            result["content"] = [
                "type": "base64Data",
                "data": data.base64EncodedString()
            ]
        }
        result["mimeType"] = mimeType.dictionaryValue
        switch self {
        case let imageFile as ImageFile:
            result["size"] = imageFile.size?.dictionaryRepresentation
        case let videoFile as VideoFile:
            result["size"] = videoFile.size?.dictionaryRepresentation
        case let audioFile as AudioFile:
            result["durationMs"] = audioFile.durationMs
        case let documentFile as DocumentFile:
            result["thumbnailURL"] = documentFile.thumbnailUrl?.absoluteString
        default:
            result["type"] = "UnknownMedia"
        }
        return result
    }
}
