import Foundation
import NablaCore
import NablaScheduling
import nabla_react_native_core

@objc(NablaSchedulingUIModule)
final class NablaSchedulingUIModule: NSObject {
    @objc(navigateToScheduleAppointmentScreen)
    func navigateToScheduleAppointmentScreen() {
        DispatchQueue.main.async {
            guard let rootViewController = Self.applicationRootViewController else {
                CoreLogger.sharedInstance.error(message: "Missing Application window rootViewController")
                return
            }
            NablaClient.shared.scheduling.views.presentScheduleAppointmentNavigationController(from: rootViewController)
        }
    }

    @objc(navigateToAppointmentDetailScreen:callback:)
    func navigateToAppointmentDetailScreen(
        _ appointmentId: String,
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let appointmentId = UUID(uuidString: appointmentId) else {
            let message = "Unable to parse appointmentId: `\(appointmentId)`"
            CoreLogger.sharedInstance.error(message: message)
            callback([InternalError.createDictionaryRepresentation(message: message)])
            return
        }
        DispatchQueue.main.async {

            if let appRootViewController = Self.applicationRootViewController {
                self.presentNavigationController(
                    rootViewController: NablaClient.shared.scheduling.views.createAppointmentDetailsViewController(
                        appointmentId: appointmentId,
                        delegate: self),
                    from: appRootViewController
                )
                self.navigateToAppointmentDetailCallback = {
                    callback([NSNull()])
                    self.navigateToAppointmentDetailCallback = nil
                }
            } else {
                let message = "Unable to open appointment detail screen"
                CoreLogger.sharedInstance.error(message: message)
                callback([InternalError.createDictionaryRepresentation(message: message)])
            }
        }
    }


    // MARK: - Overridden
    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }

    private static var applicationRootViewController: UIViewController? {
        UIApplication.shared.delegate?.window??.rootViewController
    }

    @objc private func dismissNavigationController() {
        nablaNavigationController?.dismiss(animated: true)
        nablaNavigationController = nil
        navigateToAppointmentDetailCallback?()
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
            action: #selector(dismissNavigationController))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        nablaNavigationController?.navigationBar.standardAppearance = appearance
        nablaNavigationController?.navigationBar.scrollEdgeAppearance = appearance
        nablaNavigationController?.modalPresentationStyle = .fullScreen
        nablaNavigationController.map {
            presentingViewController.present($0, animated: true)
        }
    }

    private var nablaNavigationController: UINavigationController?
    private var navigateToAppointmentDetailCallback: (() -> Void)?
}

extension NablaSchedulingUIModule: AppointmentDetailsDelegate {
    func appointmentDetailsDidCancelAppointment(_ appointment: Appointment) {
        dismissNavigationController()
    }
}
