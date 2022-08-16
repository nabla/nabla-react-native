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
        result["fileURL"] = fileUrl.absoluteString
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
