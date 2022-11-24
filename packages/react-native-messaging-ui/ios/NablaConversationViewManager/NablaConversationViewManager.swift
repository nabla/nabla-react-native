import Foundation
import NablaMessagingCore
import NablaMessagingUI

@objc(NablaConversationViewManager)
final class NablaConversationViewManager: RCTViewManager {

    override func view() -> UIView! {
        NablaConversationView()
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}


