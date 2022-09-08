import Foundation
import NablaCore
import NablaVideoCall
import nabla_react_native_core

@objc(NablaVideoCallClientModule)
final class NablaVideoCallClientModule: NSObject {

    @objc(initializeVideoCallModule:rejecter:)
    func initializeVideoCallModule(resolver: RCTPromiseResolveBlock, rejecter _: RCTPromiseRejectBlock) {
        NablaModules.addModule(NablaVideoCallModule())
        resolver(NSNull())
    }

    @objc(joinVideoCall:callback:)
    func joinVideoCall(_ room: [String: Any], callback: @escaping RCTResponseSenderBlock) {
        guard let token = room["token"] as? String else {
            callback([InternalError.createDictionaryRepresentation(message: "Missing room token")])
            return
        }
        guard let url = room["url"] as? String else {
            callback([InternalError.createDictionaryRepresentation(message: "Missing room url")])
            return
        }

        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
                return
            }
            NablaClient.shared.videoCall.openVideoCallRoom(url: url, token: token, from: rootViewController)
        }
    }

    // MARK: - Overridden

    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }
}
