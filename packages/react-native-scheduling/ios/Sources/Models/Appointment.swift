import Foundation
import NablaScheduling

extension Appointment {
    var dictionaryRepresentation: [String: Any] {
        var result: [String: Any] = [
            "id": id.uuidString,
            "scheduledAt": ISO8601DateFormatter().string(from: start),
            "provider": provider.dictionaryRepresentation,
            "location": location.dictionaryRepresentation,
        ]
        result["price"] = price?.dictionaryRepresentation
        return result
    }
}
