import Foundation
import NablaCore
import NablaScheduling
import UIKit

final class NablaAppointmentListView: UIView {

    private weak var appointmentListViewController: UIViewController?

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if appointmentListViewController == nil {
            embed()
        } else {
            appointmentListViewController?.view.frame = bounds
        }
    }

    private func embed() {
        guard let parentVC = parentViewController else { return }

        let viewController = NablaClient.shared.scheduling.views
                .createAppointmentListViewController(delegate: self)
        parentVC.addChild(viewController)
        addSubview(viewController.view)
        viewController.view.frame = bounds
        viewController.didMove(toParent: parentVC)
        appointmentListViewController = viewController
    }

    // MARK: - Private
    @objc private var onAppointmentSelected: RCTDirectEventBlock?
}

extension NablaAppointmentListView: AppointmentListDelegate {
    func appointmentListDidSelectAppointment(_ appointment: Appointment) {
        onAppointmentSelected?(["appointmentId": appointment.id.uuidString])
    }

    func appointmentListDidSelectNewAppointment() {
        parentViewController.map {
            NablaClient.shared.scheduling.views.presentScheduleAppointmentNavigationController(from: $0)
        }
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
