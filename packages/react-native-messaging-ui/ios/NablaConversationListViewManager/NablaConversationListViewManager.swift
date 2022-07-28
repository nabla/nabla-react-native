import Foundation
import NablaMessagingCore
import NablaMessagingUI

@objc(NablaConversationListViewManager)
class NablaConversationListViewManager: RCTViewManager {

    override func view() -> UIView! {
        ConversationListViewWrapper()
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}


