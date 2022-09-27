import Foundation
import NablaCore

struct Log {
    let level: Level
    let message: String
    let error: NablaError?
}

extension Log {
    struct Level {
        static let debug = Self(intValue: 0, stringValue: "debug")
        static let info = Self(intValue: 1, stringValue: "info")
        static let warn = Self(intValue: 2, stringValue: "warn")
        static let error = Self(intValue: 3, stringValue: "error")

        let intValue: Int
        let stringValue: String

        func isAtLeast(_ level: Level) -> Bool {
            intValue <= level.intValue
        }
    }
}
