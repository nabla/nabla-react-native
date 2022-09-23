import Foundation
import NablaMessagingCore

extension VideoCallRoomInteractiveMessage.Status {
    var dictionaryRepresentation: [String: Any] {
        switch self {
        case .closed:
            return ["status": "closed"]
        case .open(let room):
            return [
                "status": "open",
                "room": [
                    "id": room.token,
                    "token": room.token,
                    "url": room.url
                ]
            ]

        }
    }
}
