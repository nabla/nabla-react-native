import Foundation
import NablaCore

struct SharedNetworkConfiguration: NetworkConfiguration {
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
        if let networkConfiguration = networkConfiguration,
           let scheme = networkConfiguration["scheme"] as? String,
           let domain = networkConfiguration["domain"] as? String,
           let path = networkConfiguration["path"] as? String {

            let networkConfiguration = SharedNetworkConfiguration(
                domain: domain,
                scheme: scheme,
                port: networkConfiguration["port"] as? Int,
                path: path
            )
            NablaClient.initialize(
                modules: NablaModules.modules,
                configuration: .init(
                    apiKey: apiKey,
                    logger: CoreLogger.sharedInstance,
                    enableReporting: enableReporting
                ),
                networkConfiguration: networkConfiguration
            )
        } else {
            NablaClient.initialize(
                modules: NablaModules.modules,
                configuration: .init(
                    apiKey: apiKey,
                    logger: CoreLogger.sharedInstance,
                    enableReporting: enableReporting
                )
            )
        }
        resolver(NSNull())
    }

    @objc(willAuthenticateUser:)
    func willAuthenticateUser(userId: String) {
        currentUserId = userId
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

    override func startObserving() {
        guard let currentUserId = currentUserId else {
            return
        }
        NablaClient.shared.authenticate(userId: currentUserId, provider: self)
    }

    override func stopObserving() {
        currentUserId = nil
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

    private var currentUserId: String?
    private var provideTokensCompletion: ((AuthTokens?) -> Void)?

    private enum Event: String, CaseIterable {
        case needProvideTokens
    }
}

extension NablaClientModule: SessionTokenProvider {
    func provideTokens(forUserId _: String, completion: @escaping (AuthTokens?) -> Void) {
        provideTokensCompletion = completion
        sendEvent(withName: Event.needProvideTokens.rawValue, body: [:])
    }
}
