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

    // MARK: - Overridden

    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }
}
