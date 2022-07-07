import Foundation

extension Date {
    var iso8601String: String? {
        ISO8601DateFormatter().string(from: self)
    }
}
