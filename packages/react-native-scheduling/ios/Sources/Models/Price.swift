import Foundation
import NablaScheduling

extension Price {
    var dictionaryRepresentation: [String: Any] {
        [
            "amount": amount,
            "currencyCode": currencyCode
        ]
    }
}
