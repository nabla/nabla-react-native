import Foundation
import NablaMessagingUI
import UIKit

@objc(NablaMessagingUIClientModule)
final class NablaMessagingUIClientModule: NSObject {
    
    var conversationNavigationController: UINavigationController?
    
    @objc(navigateToConversation:showComposer:)
    func navigateToConversation(_ conversationId: String, showComposer: Bool) {
        DispatchQueue.main.async {
            guard let rootViewController =
                    UIApplication.shared.delegate?.window??.rootViewController,
                  let conversationId = UUID(uuidString: conversationId)
            else {
                return
            }
            let conversationViewController = NablaViewFactory
                .createConversationViewController(
                    conversationId,
                    showComposer: showComposer
                )
            self.conversationNavigationController = UINavigationController(
                rootViewController: conversationViewController
            )
            conversationViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                style: .plain,
                target: self,
                action: #selector(self.dismissNavigationController))
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            self.conversationNavigationController?.navigationBar.standardAppearance = appearance
            self.conversationNavigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.conversationNavigationController?.modalPresentationStyle = .fullScreen
            self.conversationNavigationController.map {
                rootViewController.present($0, animated: true)
            }
        }
    }
    
    @objc func dismissNavigationController() {
        conversationNavigationController?.dismiss(animated: true)
    }
    
    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        true
    }
}
