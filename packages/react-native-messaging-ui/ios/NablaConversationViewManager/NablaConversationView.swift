import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_messaging_core
import NablaMessagingUI
import UIKit

final class NablaConversationView: UIView {

    private weak var conversationViewController: UIViewController?

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if conversationViewController == nil {
            embed()
        } else {
            conversationViewController?.view.frame = bounds
        }
    }

    // MARK: - Private
    private var parsedConversationId: ConversationId?
    @objc private var conversationId: [String: Any]? {
        didSet {
            parsedConversationId = conversationId?.asConversationId
        }
    }

    private func embed() {
        guard let parentVC = parentViewController,
        let conversationId = parsedConversationId else { return }

        let viewController = NablaClient.shared.messaging.views.createConversationViewController(conversationId)
        parentVC.addChild(viewController)
        addSubview(viewController.view)
        viewController.view.frame = bounds
        viewController.didMove(toParent: parentVC)
        conversationViewController = viewController
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
