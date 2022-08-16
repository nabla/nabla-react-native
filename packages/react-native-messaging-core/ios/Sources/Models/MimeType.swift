import Foundation
import NablaCore

extension MimeType {
    var dictionaryValue: String {
        switch self {
        case let .image(image): return image.rawValue
        case let .video(video): return video.rawValue
        case let .audio(audio): return audio.rawValue
        case let .document(document): return document.rawValue
        }
    }
}
