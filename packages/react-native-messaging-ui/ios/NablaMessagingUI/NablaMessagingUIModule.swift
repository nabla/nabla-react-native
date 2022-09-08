import Foundation
import NablaCore
import NablaMessagingCore
import NablaMessagingUI
import nabla_react_native_messaging_core
import UIKit

@objc(NablaMessagingUIModule)
final class NablaMessagingUIModule: NSObject {
    
    private var nablaNavigationController: UINavigationController?
    
    @objc(navigateToInbox)
    func navigateToInbox() {
        DispatchQueue.main.async {
            self.presentNavigationController(
                rootViewController: NablaClient.shared.messaging.views.createInboxViewController(delegate: self)
            )
        }
    }
    
    @objc(navigateToConversation:showComposer:)
    func navigateToConversation(_ conversationIdMap: Dictionary<String, Any>, showComposer: Bool) {
        guard let conversationId = conversationIdMap.asConversationId else {
            return
        }
        DispatchQueue.main.async {
            let conversationViewController = NablaClient.shared.messaging.views
                .createConversationViewController(
                    conversationId,
                    showComposer: showComposer
                )
            self.presentNavigationController(rootViewController: conversationViewController)
        }
    }
    
    @objc func dismissNavigationController() {
        nablaNavigationController?.dismiss(animated: true)
        nablaNavigationController = nil
    }
    
    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }
    
    private func presentNavigationController(rootViewController viewController: UIViewController) {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
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
        nablaNavigationController?.navigationBar.standardAppearance = appearance
        nablaNavigationController?.navigationBar.scrollEdgeAppearance = appearance
        nablaNavigationController?.modalPresentationStyle = .fullScreen
        nablaNavigationController.map {
            rootViewController.present($0, animated: true)
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
