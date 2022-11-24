import Foundation
import NablaMessagingCore
import NablaCore

extension Dictionary where Key == String, Value: Any {
    var messageInput: MessageInput? {
        guard let type = self["type"] as? String else {
            return nil
        }

        switch (type) {
        case "text": return parseTextMessage()
        case "image": return parseImageMessage()
        case "video": return parseVideoMessage()
        case "document": return parseDocumentMessage()
        case "audio": return parseAudioMessage()
        default: return nil
        }
    }

    private func parseTextMessage() -> MessageInput? {
        guard let text = self["value"] as? String else {
            return nil
        }

        return .text(content: text)
    }

    private func parseImageMessage() -> MessageInput? {
        guard let valueDictionnary = self["value"] as? Dictionary<String, String> else {
            return nil
        }

        guard let uri = valueDictionnary["uri"] as? String else {
            return nil
        }

        guard let url = URL(string: uri) else {
            return nil
        }

        guard let mimetypeString = valueDictionnary["mimetype"] as? String else {
            return nil
        }

        let mimetype: MimeType.Image
        switch (mimetypeString) {
        case "jpeg": mimetype = .jpg
        case "png": mimetype = .png
        case "heic": mimetype = .heic
        case "heif": mimetype = .heif
        default: mimetype = .other
        }

        guard let filename = valueDictionnary["filename"] as? String else {
            return nil
        }

        return .image(content: .init(fileName: filename, source: .url(url), size: nil, mimeType: mimetype))
    }

    private func parseVideoMessage() -> MessageInput? {
        guard let valueDictionnary = self["value"] as? Dictionary<String, String> else {
            return nil
        }

        guard let uri = valueDictionnary["uri"] as? String else {
            return nil
        }

        guard let url = URL(string: uri) else {
            return nil
        }

        guard let mimetypeString = valueDictionnary["mimetype"] as? String else {
            return nil
        }

        let mimetype: MimeType.Video
        switch (mimetypeString) {
        case "mp4": mimetype = .mp4
        case "mov": mimetype = .mov
        default: mimetype = .other
        }

        guard let filename = valueDictionnary["filename"] as? String else {
            return nil
        }

        return .video(content: .init(fileName: filename, content: .url(url), size: nil, mimeType: mimetype))
    }

    private func parseDocumentMessage() -> MessageInput? {
        guard let valueDictionnary = self["value"] as? Dictionary<String, String> else {
            return nil
        }

        guard let uri = valueDictionnary["uri"] as? String else {
            return nil
        }

        guard let url = URL(string: uri) else {
            return nil
        }

        guard let mimetypeString = valueDictionnary["mimetype"] as? String else {
            return nil
        }

        let mimetype: MimeType.Document
        switch (mimetypeString) {
        case "pdf": mimetype = .pdf
        default: mimetype = .other
        }

        guard let filename = valueDictionnary["filename"] as? String else {
            return nil
        }

        return .document(content: .init(fileName: filename, content: .url(url), thumbnail: nil, mimeType: mimetype))
    }

    private func parseAudioMessage() -> MessageInput? {
        guard let valueDictionary = self["value"] as? Dictionary<String, AnyObject> else {
            return nil
        }

        guard let uri = valueDictionary["uri"] as? String else {
            return nil
        }

        guard let url = URL(string: uri) else {
            return nil
        }

        guard let mimetypeString = valueDictionary["mimetype"] as? String else {
            return nil
        }

        let mimetype: MimeType.Audio
        switch (mimetypeString) {
        case "mpeg": mimetype = .mpeg
        default: mimetype = .other
        }

        guard let filename = valueDictionary["filename"] as? String else {
            return nil
        }

        guard let durationMs = valueDictionary["estimatedDurationMs"] as? Int else {
            return nil
        }

        return .audio(content: .init(fileName: filename, content: .url(url), durationMs: durationMs, mimeType: mimetype))
    }
}
