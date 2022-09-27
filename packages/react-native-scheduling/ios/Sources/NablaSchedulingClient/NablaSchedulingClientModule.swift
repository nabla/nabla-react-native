import Foundation
import NablaCore
import NablaScheduling
import nabla_react_native_core

@objc(NablaSchedulingClientModule)
final class NablaSchedulingClientModule: NSObject {

    @objc(initializeSchedulingModule:rejecter:)
    func initializeSchedulingModule(resolver: RCTPromiseResolveBlock, rejecter _: RCTPromiseRejectBlock) {
        NablaModules.addModule(NablaSchedulingModule())
        resolver(NSNull())
    }

    @objc(openScheduleAppointmentScreen)
    func openScheduleAppointmentScreen() {
        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
                CoreLogger.sharedInstance.error(message: "Missing Application window rootViewController")
                return
            }
            NablaClient.shared.scheduling.views.presentScheduleAppointmentViewController(from: rootViewController)
        }
    }

    // MARK: - Overridden

    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }
}
