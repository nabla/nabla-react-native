import Foundation
import NablaMessagingCore

extension ConversationMessageSendingState {
    var dictionaryValue: String {
        switch self {
        case .sent: return "sent"
        case .toBeSent: return "toBeSent"
        case .sending: return "sending"
        case .failed: return "failed"
        }
    }
}
