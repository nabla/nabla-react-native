import Foundation
import NablaCore

extension RefreshingState {
    var dictionaryRepresentation: [String: Any] {
        switch self {

        case .refreshing:
            return ["type": "Refreshing"]
        case .refreshed:
            return ["type": "Refreshed"]
        case let .failed(error):
            return [
                "type": "ErrorWhileRefreshing",
                "error": error.dictionaryRepresentation
            ]
        }
    }
}

extension Response {
    func dictionaryRepresentation(
        _ dataDictionaryRepresentation: (Data) -> [String: Any]
    ) -> [String: Any] {
        [
            "isDataFresh": isDataFresh,
            "refreshingState": refreshingState.dictionaryRepresentation,
            "data": dataDictionaryRepresentation(data)

        ]
    }
}
