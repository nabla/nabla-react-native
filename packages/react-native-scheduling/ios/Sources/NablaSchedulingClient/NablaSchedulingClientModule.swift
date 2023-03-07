import Foundation
import NablaCore
import NablaScheduling
import nabla_react_native_core
import React

enum PaymentError: Error {
    case didNotProvideComponentName
    case failedFromApp
}

@objc(NablaSchedulingClientModule)
final class NablaSchedulingClientModule: NSObject {

    // MARK: - Overridden

    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        false
    }

    // MARK: - Initialize

    @objc(initializeSchedulingModule:rejecter:)
    func initializeSchedulingModule(resolver: RCTPromiseResolveBlock, rejecter _: RCTPromiseRejectBlock) {
        NablaModules.addModule(NablaSchedulingModule())
        resolver(NSNull())
    }

    // MARK: - Payment Step

    @objc(setupCustomPaymentStep:)
    func setupCustomPaymentStep(componentName: String) {
        PaymentStepConfiguration.componentName = componentName
    }

    @objc(didSucceedPaymentStep)
    func didSucceedPaymentStep() {
        guard let completion = PaymentStepConfiguration.paymentCompletion else {
            CoreLogger.sharedInstance.warning(message: "Tried to succeed payment outside of payment step")
            return
        }
        DispatchQueue.main.async {
            completion(.success(()))
            PaymentStepConfiguration.paymentCompletion = nil
        }
    }

    @objc(didFailPaymentStep)
    func didFailPaymentStep() {
        guard let completion = PaymentStepConfiguration.paymentCompletion else {
            CoreLogger.sharedInstance.warning(message: "Tried to fail payment outside of payment step")
            return
        }
        DispatchQueue.main.async {
            completion(.failure(PaymentError.failedFromApp))
            PaymentStepConfiguration.paymentCompletion = nil
        }
    }

    static func createPaymentViewController(
        for appointment: Appointment,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> UIViewController {

        PaymentStepConfiguration.paymentCompletion = completion
        guard let componentName = PaymentStepConfiguration.componentName else {
            CoreLogger.sharedInstance.error(message: "Did not register any component for the payment step")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                PaymentStepConfiguration.paymentCompletion?(.failure(PaymentError.didNotProvideComponentName))
                PaymentStepConfiguration.paymentCompletion = nil
            }
            return UIViewController()
        }

        let viewController = UIViewController()
        viewController.view = RCTRootView(
            bundleURL: sourceURL()!,
            moduleName: componentName,
            initialProperties: ["appointment": appointment.dictionaryRepresentation],
            launchOptions: nil
        )
        return viewController
    }

    private enum PaymentStepConfiguration {
        static var paymentCompletion: ((Result<Void, Error>) -> Void)?
        static var componentName: String?
    }

    static func sourceURL() -> URL? {
        #if DEBUG
        RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
}
