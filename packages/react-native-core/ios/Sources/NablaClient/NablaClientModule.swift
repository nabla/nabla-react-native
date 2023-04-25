import Foundation
import NablaCore

struct NetworkConfiguration: NablaCore.NetworkConfiguration {
    let domain: String
    let scheme: String
    let port: Int?
    let path: String
    let session: URLSession = .shared
}

public enum NablaModules {
    static var modules: [Module] = []
    
    public static func addModule(_ module: Module) {
        modules.append(module)
    }
}

@objc(NablaClientModule)
final class NablaClientModule: RCTEventEmitter {

    @objc(initialize:enableReporting:networkConfiguration:resolver:rejecter:)
    func initialize(
        apiKey: String,
        enableReporting: Bool,
        networkConfiguration: [String: Any]?,
        resolver: RCTPromiseResolveBlock,
        rejecter _: RCTPromiseRejectBlock
    ) {
        var configuration = Configuration(
            apiKey: apiKey,
            enableReporting: enableReporting,
            logger: CoreLogger.sharedInstance
        )

        if let networkConfiguration = networkConfiguration,
           let scheme = networkConfiguration["scheme"] as? String,
           let domain = networkConfiguration["domain"] as? String,
           let path = networkConfiguration["path"] as? String {

            configuration.network = NetworkConfiguration(
                domain: domain,
                scheme: scheme,
                port: networkConfiguration["port"] as? Int,
                path: path
            )

        }
        NablaClient.initialize(
            configuration: configuration,
            modules: NablaModules.modules,
            sessionTokenProvider: self
        )
        resolver(NSNull())
    }

    @objc(setCurrentUser:resolver:rejecter:)
    func setCurrentUser(
        userId: String,
        resolver: RCTPromiseResolveBlock,
        rejecter: RCTPromiseRejectBlock
    ) {
        do {
            try NablaClient.shared.setCurrentUser(userId: userId)
            resolver(NSNull())
        } catch {
            let dictionaryRepresentation = error.dictionaryRepresentation

            rejecter(
                "\(dictionaryRepresentation["code"] ?? error._code)",
                dictionaryRepresentation["message"] as? String ?? error._domain,
                error
            )
        }
    }

    @objc(clearCurrentUser:rejecter:)
    func clearCurrentUser(
        resolver: @escaping RCTPromiseResolveBlock,
        rejecter _: RCTPromiseRejectBlock
    ) {
        Task {
            await NablaClient.shared.clearCurrentUser()
            resolver(NSNull())
        }
    }

    @objc(getCurrentUserId:rejecter:)
    func getCurrentUserId(
        resolver: @escaping RCTPromiseResolveBlock,
        rejecter _: RCTPromiseRejectBlock
    ) {
        resolver(NablaClient.shared.currentUserId)
    }

    @objc(provideTokens:accessToken:)
    func provideTokens(refreshToken: String, accessToken: String) {
        provideTokensCompletion?(
            AuthTokens(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }


    // MARK: - Overridden

    override func stopObserving() {
        provideTokensCompletion = nil
    }

    override func supportedEvents() -> [String]! {
        Event.allCases.map(\.rawValue)
    }

    @objc(requiresMainQueueSetup)
    override static func requiresMainQueueSetup() -> Bool {
        false
    }

    // MARK: - Private

    private var provideTokensCompletion: ((AuthTokens?) -> Void)?

    private enum Event: String, CaseIterable {
        case needProvideTokens
    }
}

extension NablaClientModule: SessionTokenProvider {
    func provideTokens(forUserId userId: String, completion: @escaping (AuthTokens?) -> Void) {
        provideTokensCompletion = completion
        sendEvent(withName: Event.needProvideTokens.rawValue, body: ["userId": userId])
    }
}
