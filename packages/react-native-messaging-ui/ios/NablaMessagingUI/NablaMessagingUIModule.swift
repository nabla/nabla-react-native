import Foundation
import NablaCore
import NablaMessagingCore
import NablaMessagingUI
import nabla_react_native_core
import nabla_react_native_messaging_core
import UIKit

@objc(NablaMessagingUIModule)
final class NablaMessagingUIModule: NSObject {

    private var nablaNavigationController: UINavigationController?
    private var navigateToInboxCallback: (() -> Void)?
    private var navigateToConversationCallback: (() -> Void)?

    @objc(navigateToInbox:)
    func navigateToInbox(callback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            if let appRootViewController = UIApplication.shared.delegate?.window??.rootViewController {
                self.presentNavigationController(
                    rootViewController: NablaClient.shared.messaging.views.createInboxViewController(delegate: self),
                    from: appRootViewController
                )
                self.navigateToInboxCallback = {
                    callback([NSNull()])
                    self.navigateToInboxCallback = nil
                }
            } else {
                let message = "Unable to open inbox screen"
                CoreLogger.sharedInstance.warning(message: message)
                callback([InternalError.createDictionaryRepresentation(message: message)])
            }
        }
    }

    @objc(navigateToConversation:showComposer:callback:)
    func navigateToConversation(
        _ conversationIdMap: [String: Any],
        showComposer: Bool,
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            let message = "Unable to parse conversationId: `\(conversationIdMap)`"
            CoreLogger.sharedInstance.warning(message: message)
            callback([InternalError.createDictionaryRepresentation(message: message)])
            return
        }
        DispatchQueue.main.async {
            let conversationViewController = NablaClient.shared.messaging.views
                    .createConversationViewController(
                        conversationId,
                        showComposer: showComposer
                    )
            if let appRootViewController = UIApplication.shared.delegate?.window??.rootViewController {
                self.presentNavigationController(rootViewController: conversationViewController, from: appRootViewController)
                self.navigateToConversationCallback = {
                    callback([NSNull()])
                    self.navigateToConversationCallback = nil
                }
            } else {
                let message = "Unable to open ConversationScreen"
                CoreLogger.sharedInstance.warning(message: message)
                callback([InternalError.createDictionaryRepresentation(message: message)])
                return
            }
        }
    }

    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }

    @objc private func dismissNavigationController() {
        nablaNavigationController?.dismiss(animated: true)
        nablaNavigationController = nil
        navigateToInboxCallback?()
        navigateToConversationCallback?()
    }

    private func presentNavigationController(
        rootViewController viewController: UIViewController,
        from presentingViewController: UIViewController
    ) {
        nablaNavigationController = UINavigationController(
            rootViewController: viewController
        )
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(self.dismissNavigationController))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = appearance.backgroundColor?.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        appearance.titleTextAttributes[.foregroundColor] = (appearance.titleTextAttributes[.foregroundColor] as? UIColor)?
                .resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        appearance.largeTitleTextAttributes[.foregroundColor] = (appearance.largeTitleTextAttributes[.foregroundColor] as? UIColor)?
                .resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        nablaNavigationController?.navigationBar.standardAppearance = appearance
        nablaNavigationController?.navigationBar.scrollEdgeAppearance = appearance
        nablaNavigationController?.modalPresentationStyle = .fullScreen
        nablaNavigationController.map {
            presentingViewController.present($0, animated: true)
        }
    }
}

extension NablaMessagingUIModule: InboxDelegate {
    func inbox(didCreate conversation: Conversation) {
        pushConversationViewController(conversation: conversation)
    }

    func inbox(didSelect conversation: Conversation) {
        pushConversationViewController(conversation: conversation)
    }

    private func pushConversationViewController(conversation: Conversation) {
        let conversationViewController = NablaClient.shared.messaging.views.createConversationViewController(conversation.id)
        conversationViewController.navigationItem.largeTitleDisplayMode = .never
        nablaNavigationController?.pushViewController(
            conversationViewController,
            animated: true
        )
    }
}
