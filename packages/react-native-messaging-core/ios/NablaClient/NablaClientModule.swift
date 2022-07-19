import Foundation
import NablaCore
import NablaMessagingCore

struct SharedNetworkConfiguration: NetworkConfiguration {
    let domain: String
    let scheme: String
    let port: Int?
    let path: String
    let session: URLSession = .shared
}

@objc(NablaClientModule)
final class NablaClientModule: RCTEventEmitter {

    @objc(initialize:networkConfiguration:)
    func initialize(apiKey: String, networkConfiguration: Dictionary<String, Any>?) {

        if let networkConfiguration = networkConfiguration,
            let scheme = networkConfiguration["scheme"] as? String,
            let domain = networkConfiguration["domain"] as? String,
            let path = networkConfiguration["path"] as? String {

            let configuration = SharedNetworkConfiguration(
                domain: domain,
                scheme: scheme,
                port: networkConfiguration["port"] as? Int,
                path: path
            )
            NablaClient.initialize(apiKey: apiKey, networkConfiguration: configuration)
        } else {
            NablaClient.initialize(apiKey: apiKey)
        }
    }

    @objc(willAuthenticateUser:)
    func willAuthenticateUser(userId: String) {
        currentUserId = UUID(uuidString: userId)
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

    private var currentUserId: UUID?
    private var provideTokensCompletion: ((AuthTokens?) -> Void)?

    private enum Event: String, CaseIterable {
        case needProvideTokens
    }
}

extension NablaClientModule: SessionTokenProvider {
    func provideTokens(forUserId userId: UUID, completion: @escaping (AuthTokens?) -> Void) {
        provideTokensCompletion = completion
        sendEvent(withName: Event.needProvideTokens.rawValue, body: [:])
    }
}
