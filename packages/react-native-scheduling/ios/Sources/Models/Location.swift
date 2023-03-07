import Foundation
import NablaScheduling

extension Location {
    var dictionaryRepresentation: [String: Any] {
        switch self {

        case let .physical(physicalLocation):
            return ["type": "Physical"]
        case let .remote(remoteLocation):
            return ["type": "Remote"]
        case .unknown:
            return ["type": "Unknown"]
        }
    }
}
