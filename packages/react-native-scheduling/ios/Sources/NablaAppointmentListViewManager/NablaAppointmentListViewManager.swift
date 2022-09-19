import Foundation

@objc(NablaAppointmentListViewManager)
class NablaAppointmentListViewManager: RCTViewManager {

    override func view() -> UIView! {
        NablaAppointmentListView()
    }

    override class func requiresMainQueueSetup() -> Bool {
        false
    }
}


